defmodule Pento.Accounts.Scope do
  @moduledoc """
  Defines the scope of the caller to be used throughout the app.

  The `Pento.Accounts.Scope` allows public interfaces to receive
  information about the caller, such as if the call is initiated from an
  end-user, and if so, which user. Additionally, such a scope can carry fields
  such as "super user" or other privileges for use as authorization, or to
  ensure specific code paths can only be access for a given scope.

  It is useful for logging as well as for scoping pubsub subscriptions and
  broadcasts when a caller subscribes to an interface or performs a particular
  action.

  Feel free to extend the fields on this struct to fit the needs of
  growing application requirements.
  """

  alias Pento.Accounts.User

  defstruct user: nil,
            role: :guest,
            preferences: %{},
            permissions: []

  @default_preferences %{
    theme: "light",
    difficulty: :easy,
    guess_range: 1..10
  }

  @doc """
  Creates a scope for the given user.

  Returns nil if no user is given.
  """
  def for_user(%User{} = user) do
    role = role_for(user)

    %__MODULE__{
      user: user,
      role: role,
      preferences: preferences_for(user),
      permissions: permissions_for(role)
    }
  end

  def for_user(nil), do: nil

  @doc "Returns true when the scope belongs to an admin user."
  def admin?(%__MODULE__{role: :admin}), do: true
  def admin?(_), do: false

  @doc "Returns true when the scope is allowed to perform the given action."
  def can?(%__MODULE__{permissions: perms}, action), do: action in perms
  def can?(_, _), do: false

  # Derive a role from the user. Admin status is granted to addresses
  # ending in @admin.com; everyone else is a regular member.
  defp role_for(%User{email: email}) when is_binary(email) do
    if String.ends_with?(email, "@admin.com"), do: :admin, else: :member
  end

  defp role_for(_), do: :member

  # User-specific preferences. Admins get a harder default range.
  defp preferences_for(%User{} = user) do
    case role_for(user) do
      :admin -> Map.put(@default_preferences, :guess_range, 1..100)
      _ -> @default_preferences
    end
  end

  defp permissions_for(:admin), do: [:play_game, :view_settings, :manage_users]
  defp permissions_for(:member), do: [:play_game, :view_settings]
  defp permissions_for(_), do: []
end
