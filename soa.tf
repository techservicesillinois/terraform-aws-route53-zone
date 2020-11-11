# Default values used for SOA when specified.

locals {
  # 1 1800 300 604800 86400
  _default_hostmaster = "awsdns-hostmaster.amazon.com"
  _default_refresh    = 30 * 60          # 30 minutes
  _default_retry      = 5 * 60           # 5 minutes
  _default_expire     = 7 * 24 * 60 * 60 # 7 days
  _default_ttl        = 24 * 60 * 60     # 24 hours
}

locals {
  # SOA object constructed from arguments and defaults.
  soa = {
    serial  = (length(var.soa) > 0) ? lookup(var.soa, "serial") : null
    refresh = (length(var.soa) > 0) ? lookup(var.soa, "refresh", local._default_refresh) : null
    retry   = (length(var.soa) > 0) ? lookup(var.soa, "retry", local._default_retry) : null
    expire  = (length(var.soa) > 0) ? lookup(var.soa, "expire", local._default_expire) : null
    ttl     = (length(var.soa) > 0) ? lookup(var.soa, "ttl", local._default_ttl) : null
  }
}

# Construct SOA record if requested.

locals {
  soa_record = (length(var.soa) == 0) ? null : format("%s. %s. %d %d %d %d %d",
    aws_route53_zone.default.name_servers[0], local._default_hostmaster,
    local.soa.serial, local.soa.refresh, local.soa.retry,
  local.soa.expire, local.soa.ttl)
}

resource "aws_route53_record" "soa" {
  count = (local.soa_record != null) ? 1 : 0

  allow_overwrite = true
  zone_id         = aws_route53_zone.default.zone_id
  name            = aws_route53_zone.default.name
  type            = "SOA"
  ttl             = var.parent_ttl

  records = [local.soa_record]
}

# ns-2048.awsdns-64.net. hostmaster.example.com. 1 7200 900 1209600 86400
#
# A SOA record includes the following elements:
#
# The Route 53 name server that created the SOA record, for example,
# ns-2048.awsdns-64.net.
#
# The email address of the administrator. The @ symbol is replaced by
# a period, for example, hostmaster.example.com. The default value is
# an amazon.com email address that is not monitored.
#
# A serial number that you can optionally increment whenever you update
# a record in the hosted zone. Route 53 doesn't increment the number
# automatically. (The serial number is used by DNS services that
# support secondary DNS.) In the example, this value is 1.
#
# A refresh time in seconds that secondary DNS servers wait before
# querying the primary DNS server's SOA record to check for changes.
# In the example, this value is 7200.
#
# The retry interval in seconds that a secondary server waits
# before retrying a failed zone transfer. Normally, the retry time is
# less than the refresh time. In the example, this value is 900
# (15 minutes).
#
# The time in seconds that a secondary server will keep trying to
# complete a zone transfer. If this time elapses before a successful
# zone transfer, the secondary server will stop answering queries
# because it considers its data too old to be reliable. In the example,
# this value is 1209600 (two weeks).
#
# The minimum time to live (TTL). This value helps define the length
# of time that recursive resolvers should cache the following responses
# from Route 53:
#
# NXDOMAIN
# There is no record of any type with the name that is specified
# in the DNS query, such as example.com. There also are no records
# that are children of the name that is specified in the DNS query,
# such as zenith.example.com.
#
# NODATA
# There is at least one record with the name that is specified in the
# DNS query, but none of those records have the type (such as A) that
# is specified in the DNS query.
#
# When a DNS resolver caches an NXDOMAIN or NODATA response, this is
# referred to as negative caching.
#
# The duration of negative caching is the lesser of the following values:
#
# This value: the minimum TTL in the SOA record. In the example, the
# value is 86400 (one day).
#
# The value of the TTL for the SOA record. The default value is 900
# seconds.
