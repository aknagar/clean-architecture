
*Container is not starting*
https://stackoverflow.com/questions/72362826/azure-container-apps-restarts-every-30-seconds
If your Container App’s HTTP ingress is set to ‘Enabled’, the platform will try to ping it on the specified Target port (80 by default). If the platform can’t successfully ping it, it will be considered 'unhealthy' and will be restarted. Please refer to Health probes in Azure Container Apps to learn about the default health probes and how to specify your own settings.

If your Container App is not listening in the specified ingress port (for example, if your app is processing messages from a queue and not expecting external http requests) set HTTP ingress to ‘Disabled’. When HTTP ingress is set to ‘Disabled’, health probes won't be configured, and your app won't be pinged