consul {
  address = "127.0.0.1:8500"

  retry {
    enabled  = true
    attempts = 12
    backoff  = "500ms"
  }
}
template {
  source      = "/etc/nginx/conf.d/load-balancer.conf.ctmpl"
  destination = "/etc/nginx/conf.d/load-balancer.conf"
  perms       = 0600
  command     = "service nginx reload"
}
