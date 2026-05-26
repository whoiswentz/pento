defmodule PentoWeb.FaqLive.Form do
  use PentoWeb, :live_view

  alias Pento.FAQ
  alias Pento.FAQ.Faq

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage faq records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="faq-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:question]} type="text" label="Question" />
        <.input field={@form[:answer]} type="textarea" label="Answer" />
        <.input field={@form[:votes]} type="number" label="Votes" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Faq</.button>
          <.button navigate={return_path(@return_to, @faq)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    faq = FAQ.get_faq!(id)

    socket
    |> assign(:page_title, "Edit Faq")
    |> assign(:faq, faq)
    |> assign(:form, to_form(FAQ.change_faq(faq)))
  end

  defp apply_action(socket, :new, _params) do
    faq = %Faq{}

    socket
    |> assign(:page_title, "New Faq")
    |> assign(:faq, faq)
    |> assign(:form, to_form(FAQ.change_faq(faq)))
  end

  @impl true
  def handle_event("validate", %{"faq" => faq_params}, socket) do
    changeset = FAQ.change_faq(socket.assigns.faq, faq_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"faq" => faq_params}, socket) do
    save_faq(socket, socket.assigns.live_action, faq_params)
  end

  defp save_faq(socket, :edit, faq_params) do
    case FAQ.update_faq(socket.assigns.faq, faq_params) do
      {:ok, faq} ->
        {:noreply,
         socket
         |> put_flash(:info, "Faq updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, faq))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_faq(socket, :new, faq_params) do
    case FAQ.create_faq(faq_params) do
      {:ok, faq} ->
        {:noreply,
         socket
         |> put_flash(:info, "Faq created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, faq))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _faq), do: ~p"/faqs"
  defp return_path("show", faq), do: ~p"/faqs/#{faq}"
end
