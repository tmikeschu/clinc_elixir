defmodule Factories do
  def base_request do
    %{
      ai_version: "0634e1e2-7392-4550-824a-e4ec201e93c1",
      device: "default",
      dialaog: "HL4JqjMHT0jLPRe3X0nni5Ic5mtFtTN6",
      external_user_id: "1",
      intent: "clean_hello_start",
      intent_probability: 0.6871070981756203,
      lat: 0,
      lon: 0,
      qid: "97c60b18-dfb5-446d-a3dc-d53db4a34ebab",
      query: "hello",
      sentiment: 0,
      session_id: "edb7a711408444bbac9d54e14dfa43f9",
      slots: %{},
      state: "clean_hello",
      time_offset: 0
    }
  end

  def accounts do
    accounts = [
      %{
        type: :checking,
        id: 10,
        account: 1234,
        routing: 4321,
        balance: 4000
      },
      %{
        type: :savings,
        id: 101,
        account: 7890,
        routing: 9087,
        balance: 200
      }
    ]
  end
end
