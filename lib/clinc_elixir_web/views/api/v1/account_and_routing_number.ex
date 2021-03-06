defmodule ClincElixirWeb.Api.V1.AccountAndRoutingNumber do
  use ClincElixirWeb.Api.V1.Renderer

  # fake account data
  # toggle comment on second element to trigger multiple/single accounts
  @accounts [
    %{
      type: :checking,
      id: 10,
      account: 1234,
      routing: 4321
    },
    %{
      type: :savings,
      id: 101,
      account: 7890,
      routing: 9087
    }
  ]

  @doc """
  Handles the BL transition from account_and_routing_number to _otp.
  Business logic transitions to the otp state run an initial request before a user says anything
  """
  def render(%{
        request:
          body = %{
            state: state = "account_and_routing_number_otp",
            intent: intent
          }
      })
      when intent in [
             "account_and_routing_number_start&account_and_routing_number_update",
             "account_and_routing_number_start"
           ] do
    handling = "OTP_AUTO_TRANSITION"

    body
    |> log(:req, handling)
    |> add_response_slots(state, %{response_key: "otp_init"})
    |> log(:res, handling)
  end

  @doc """
  Handles a user entering their otp.
  For the six digit passcode, the query itself is used as the value.
  """
  def render(%{
        request:
          body = %{
            state: state = "account_and_routing_number_otp",
            intent: "account_and_routing_number_otp_update",
            query: query
          }
      }) do
    handling = "OTP_ATTEMPT"

    case query do
      "123456" ->
        body
        |> log(:req, handling)
        |> send_to_base
        |> log(:res, handling)

      _ ->
        body
        |> log(:req, handling)
        |> add_response_slots(state, %{
          response_key: "otp_incorrect"
        })
        |> log(:res, handling)
    end
  end

  @doc """
  Handles the final success case where information is displayed.
  """
  def render(%{
        request:
          body = %{
            state: state = "account_and_routing_number",
            intent: "account_and_routing_number_otp_update",
            slots: %{
              _ACCOUNTS_: %{
                values: accounts
              }
            }
          }
      }) do
    handling = "ACCOUNT_AND_ROUTING_NUMBER_SUCCESS"

    body
    |> log(:req, handling)
    |> add_response_slots(state, %{
      response_key: if(length(accounts) == 1, do: "single_account", else: "multiple_accounts"),
      accounts_list: Enum.map(accounts, &Enum.find(@accounts, fn a -> a.id == &1.account_id end))
    })
    |> log(:res, handling)
  end

  @doc """
  Handles case where user cancels from otp
  E.g., "checking"
  """
  def render(%{
        request:
          body = %{
            state: state = "account_and_routing_number",
            intent: "cs_cancel"
          }
      }) do
    body
    |> log(:req, "OTP_CANCEL")
    |> add_response_slots(state, %{
      response_key: "otp_cancel"
    })
    |> log(:res, "OTP_CANCEL")
  end

  @doc """
  Handles case where user provides account qualifier
  E.g., "checking"
  """
  def render(%{
        request:
          body = %{
            state: "account_and_routing_number",
            slots: %{_ACCOUNTS_: _}
          }
      }) do
    body
    |> log(:req, "FROM_ROOT_WITH_QUALIFIER")
    |> resolve_accounts
    |> send_to_otp
    |> log(:res, "FROM_ROOT_WITH_QUALIFIER")
  end

  @doc """
  Disambiguates user request that doesn't specify account type.

  If no accounts, response key specified.
  If only one account exists, sent to otp.
  If multiple accounts, response key specified.
  """
  def render(%{
        request:
          %{
            state: state = "account_and_routing_number",
            slots: %{}
          } = body
      }) do
    handling = "FROM_ROOT_NO_SLOTS"

    case @accounts do
      [] ->
        body
        |> log(:req, handling)
        |> add_response_slots(state, %{
          response_key: "no_accounts"
        })
        |> log(:res, handling)

      [single_account] ->
        body
        |> log(:req, handling)
        |> resolve_single_account(single_account.id)
        |> send_to_otp
        |> log(:res, handling)

      account_list ->
        body
        |> log(:req, handling)
        |> add_slot(
          :_ACCOUNTS_,
          %{
            type: "string",
            values:
              account_list
              |> Enum.map(&%{resolved: 1, account_id: &1.id})
          }
        )
        |> send_to_otp
        |> log(:res, handling)
    end
  end

  defp resolve_single_account(body, account_id) do
    put_in(
      body,
      [:slots, :_ACCOUNTS_],
      %{type: "string", values: [%{account_id: account_id, resolved: 1}]}
    )
  end

  defp resolve_accounts(body) do
    body
    |> resolve_slot(:_ACCOUNTS_)
    |> update_in(
      [:slots, :_ACCOUNTS_, :values],
      fn [v | rest] ->
        by_type = &(Atom.to_string(&1.type) == get_account_token(v))
        account = Enum.find(@accounts, %{id: nil}, by_type)
        [Map.merge(v, %{account_id: account.id}) | rest]
      end
    )
  end

  defp get_account_token(%{account_dest: a}), do: a
  defp get_account_token(%{tokens: t}), do: t
  defp get_account_token(_), do: ""

  defp send_to_otp(body) do
    Map.replace!(body, :state, "account_and_routing_number_otp")
  end

  defp send_to_base(body) do
    Map.replace!(body, :state, "account_and_routing_number")
  end
end
