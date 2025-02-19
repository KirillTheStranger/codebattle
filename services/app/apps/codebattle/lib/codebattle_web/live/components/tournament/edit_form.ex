defmodule CodebattleWeb.Live.Tournament.EditFormComponent do
  use CodebattleWeb, :live_component
  import CodebattleWeb.ErrorHelpers

  @impl true
  def mount(socket) do
    {:ok, assign(socket, initialized: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container-xl bg-white shadow-sm rounded py-4">
      <h2 class="text-center">Edit tournament</h2>
      <h3 class="text-center">
        Creator:
        <a href={Routes.user_path(@socket, :show, @tournament.creator.id)}>
          <%= @tournament.creator.name %>
        </a>
      </h3>

      <.form
        :let={f}
        for={@changeset}
        phx-change="validate"
        phx-submit="update"
        class="col-12 col-md-8 col-lg-8 col-xl-8 offset-md-2 offset-lg-2 offset-xl-2"
      >
        <%= hidden_input(f, :tournament_id, value: @tournament.id) %>
        <div class="form-group">
          <%= render_base_errors(@changeset.errors[:base]) %>
        </div>
        <div class="d-flex flex-column flex-md-row flex-lg-row flex-xl-row justify-content-between">
          <div class="d-flex flex-column justify-content-between w-100">
            <%= label(f, :name) %>
            <%= text_input(f, :name,
              class: "form-control",
              maxlength: "42",
              required: true
            ) %>
            <%= error_tag(f, :name) %>
          </div>
          <div class="d-flex flex-column justify-content-between w-100 ml-md-3 ml-lg-3 ml-xl-3">
            <%= label(f, :type) %>
            <%= select(f, :type, Codebattle.Tournament.types(), class: "custom-select") %>
            <%= error_tag(f, :type) %>
          </div>
        </div>
        <div class="mt-3">
          <div class="d-flex flex-column justify-content-between w-auto">
            <%= label(f, :description) %>
            <%= textarea(f, :description,
              class: "form-control",
              maxlength: "1357",
              required: true
            ) %>
            <%= error_tag(f, :description) %>
          </div>
        </div>
        <div class="d-flex flex-column flex-md-row flex-lg-row flex-xl-row mt-3">
          <div class="d-flex flex-column justify-content-between w-auto">
            <label>Starts at (<%= @user_timezone %>)</label>
            <%= datetime_local_input(f, :starts_at,
              class: "form-control",
              value: DateTime.shift_zone!(f.data.starts_at, @user_timezone),
              required: true
            ) %>
            <%= error_tag(f, :starts_at) %>
          </div>
          <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
            <%= label(f, :access_type) %>
            <%= select(f, :access_type, Codebattle.Tournament.access_types(), class: "custom-select") %>
            <%= error_tag(f, :access_type) %>
          </div>
        </div>
        <div class="d-flex mt-3">
          <div class="form-check">
            <%= checkbox(f, :use_chat, class: "form-check-input") %>
            <%= label(f, :use_chat, class: "form-check-label") %>
            <%= error_tag(f, :use_chat) %>
          </div>
          <div class="form-check ml-3">
            <%= checkbox(f, :use_timer, class: "form-check-input") %>
            <%= label(f, :use_timer, class: "form-check-label") %>
            <%= error_tag(f, :use_timer) %>
          </div>
        </div>
        <div class="d-flex flex-column flex-md-row flex-lg-row flex-xl-row mt-3">
          <div class="d-flex flex-column justify-content-between w-auto">
            <%= label(f, :task_strategy) %>
            <%= select(f, :task_strategy, Codebattle.Tournament.task_strategies(),
              class: "custom-select"
            ) %>
            <%= error_tag(f, :task_strategy) %>
          </div>
          <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
            <%= label(f, :task_provider) %>
            <%= select(f, :task_provider, Codebattle.Tournament.task_providers(),
              class: "custom-select"
            ) %>
            <%= error_tag(f, :task_provider) %>
          </div>
          <%= if (f.params["task_provider"] == "level" || f.data.task_provider == "level") do %>
            <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
              <%= label(f, :level) %>
              <%= select(f, :level, Codebattle.Tournament.levels(), class: "custom-select") %>
              <%= error_tag(f, :level) %>
            </div>
          <% end %>
          <%= if (f.params["task_provider"] == "task_pack" || f.data.task_provider == "task_pack") do %>
            <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
              <%= label(f, :task_pack_name) %>
              <%= select(f, :task_pack_name, @task_pack_names,
                class: "custom-select",
                value: f.params["task_pack_name"] || f.data.task_pack_name
              ) %>
              <%= error_tag(f, :task_pack_name) %>
            </div>
          <% end %>
          <%= if (f.params["task_provider"] == "tags" || f.data.task_provider == "tags") do %>
            <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
              <%= label(f, :tags) %>
              <%= text_input(f, :tags,
                class: "form-control",
                placeholder: "strings,math"
              ) %>
              <%= error_tag(f, :tags) %>
            </div>
          <% end %>
        </div>

        <div class="d-flex flex-column flex-lg-row flex-xl-row mt-3">
          <div class="d-flex flex-column flex-md-row flex-lg-row flex-xl-row">
            <div class="d-flex flex-column justify-content-between w-auto">
              <%= label(f, :players_limit) %>
              <%= select(
                f,
                :players_limit,
                [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384],
                class: "custom-select"
              ) %>
              <%= error_tag(f, :players_limit) %>
            </div>
            <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
              <%= label(f, :default_language) %>
              <%= select(f, :default_language, @langs, class: "custom-select") %>
              <%= error_tag(f, :default_language) %>
            </div>
          </div>
          <div class="d-flex flex-column flex-md-row flex-lg-row flex-xl-row mt-md-3 mt-lg-0 mt-xl-0">
            <div class="d-flex flex-column justify-content-between w-auto ml-lg-2 ml-xl-2">
              <%= label(f, :match_timeout_seconds) %>
              <%= number_input(
                f,
                :match_timeout_seconds,
                class: "form-control",
                min: "7",
                max: "10000"
              ) %>
              <%= error_tag(f, :break_duration_seconds) %>
            </div>
            <div class="d-flex flex-column justify-content-between w-auto ml-md-2 ml-lg-2 ml-xl-2">
              <%= label(f, :break_duration_seconds) %>
              <%= number_input(
                f,
                :break_duration_seconds,
                class: "form-control",
                min: "0",
                max: "1957"
              ) %>
              <%= error_tag(f, :break_duration_seconds) %>
            </div>
          </div>
        </div>

        <div class="mt-3">
          <div class="d-flex flex-column justify-content-between w-auto">
            <%= label(f, :meta_json) %>
            <%= textarea(f, :meta_json,
              class: "form-control",
              value: (f.params["meta"] && Jason.encode!(f.params["meta"])) || "{}"
            ) %>
            <%= error_tag(f, :meta_json) %>
          </div>
        </div>

        <%= submit("Update",
          phx_disable_with: "Updating...",
          class: "btn btn-primary rounded-lg my-4"
        ) %>
        <a
          class="btn btn-info text-white rounded-lg ml-2"
          href={Routes.tournament_path(@socket, :show, @tournament.id)}
        >
          Back to tournament
        </a>
      </.form>
    </div>
    """
  end

  def render_base_errors(nil), do: nil
  def render_base_errors(errors), do: elem(errors, 0)
end
