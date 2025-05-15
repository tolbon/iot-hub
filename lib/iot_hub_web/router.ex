defmodule IotHubWeb.Router do
  use IotHubWeb, :router

  import IotHubWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {IotHubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_api_user
  end

  scope "/", IotHubWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api/hubs/", IotHubWeb do
     pipe_through :api

     post "/:hub_name/devices/:device_id/action/:action_name", Api.Devices.DeviceActionController, :action_call
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:iot_hub, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: IotHubWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/admin", IotHubWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{IotHubWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/admin", IotHubWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{IotHubWeb.UserAuth, :ensure_authenticated}],
      layout: {IotHubWeb.Layouts, :admin} do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/codecs", CodecLive.Index, :index
      live "/codecs/new", CodecLive.Index, :new
      live "/codecs/:id/edit", CodecLive.Index, :edit

      live "/codecs/:id", CodecLive.Show, :show
      live "/codecs/:id/show/edit", CodecLive.Show, :edit

      live "/hubs", HubLive.Index, :index
      live "/hubs/new", HubLive.Index, :new
      live "/hubs/:id/edit", HubLive.Index, :edit
      live "/hubs/:id", HubLive.Show, :show
      live "/hubs/:id/show/edit", HubLive.Show, :edit

      live "/hubs/:hub_id/device_models", DeviceModelLive.Index, :index
      live "/hubs/:hub_id/device_models/new", DeviceModelLive.Index, :new
      live "/hubs/:hub_id/device_models/:id/edit", DeviceModelLive.Index, :edit
      live "/hubs/:hub_id/device_models/:id", DeviceModelLive.Show, :show
      live "/hubs/:hub_id/device_models/:id/show/edit", DeviceModelLive.Show, :edit

      live "/hubs/:hub_id/firmwares", FirmwareLive.Index, :index
      live "/hubs/:hub_id/firmwares/new", FirmwareLive.Index, :new
      live "/hubs/:hub_id/firmwares/:id/edit", FirmwareLive.Index, :edit
      live "/hubs/:hub_id/firmwares/:id", FirmwareLive.Show, :show
      live "/hubs/:hub_id/firmwares/:id/show/edit", FirmwareLive.Show, :edit

      live "/hubs/:hub_id/devices", DeviceLive.Index, :index
      live "/hubs/:hub_id/devices/new", DeviceLive.Index, :new
      live "/hubs/:hub_id/devices/:id/edit", DeviceLive.Index, :edit
      live "/hubs/:hub_id/devices/:id", DeviceLive.Show, :show
      live "/hubs/:hub_id/devices/:id/show/edit", DeviceLive.Show, :edit

      live "/hubs/:hub_id/codecs_hubs", CodecHubLive.Index, :index
      live "/hubs/:hub_id/codecs_hubs/new", CodecHubLive.Index, :new
      live "/hubs/:hub_id/codecs_hubs/:id/edit", CodecHubLive.Index, :edit

      live "/hubs/:hub_id/codecs_hubs/:id", CodecHubLive.Show, :show
      live "/hubs/:hub_id/codecs_hubs/:id/show/edit", CodecHubLive.Show, :edit

      live "/hubs/:hub_id/users_hubs", UserHubLive.Index, :index
      live "/hubs/:hub_id/users_hubs/new", UserHubLive.Index, :new
      live "/hubs/:hub_id/users_hubs/:id/edit", UserHubLive.Index, :edit

      live "/hubs/:hub_id/users_hubs/:id", UserHubLive.Show, :show
      live "/hubs/:hub_id/users_hubs/:id/show/edit", UserHubLive.Show, :edit
    end
  end

  scope "/admin", IotHubWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{IotHubWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
