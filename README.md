# route53-zone

[![Terraform actions status](https://github.com/techservicesillinois/terraform-aws-route53-zone/workflows/terraform/badge.svg)](https://github.com/techservicesillinois/terraform-aws-route53-zone/actions)

Provide a Route 53 zone, optionally allowing a custom Start of Authority (SOA) record. 

For more information about DNS, and specifically about SOA records, see [RFC 1034](https://tools.ietf.org/html/rfc1034.).

Example Usage
-----------------
Creating a Route 53 zone using default SOA record provided by Route 53.

```
module "zone" {
  source = "git@github.com:techservicesillinois/terraform-aws-route53-zone"

  name = "myzone.example.org"
}
```

Creating a Route 53 zone with a custom Start of Authority (SOA) record:

```
module "zone" {
  source = "git@github.com:techservicesillinois/terraform-aws-route53-zone"

  name = "myzone.example.org"

  soa = {
    serial = 2         # NOTE: Increment serial whenever changing SOA record.
    ttl    = 10 * 60   # 10 minutes
  }
}
```

Argument Reference
-----------------
* `name` – (Required) Name of the hosted zone.
* `comment` – (Optional) Comment for the hosted zone.
* `vpc` – (Optional) VPC name for internal Route 53 zone.
* `parent_name` – (Optional) Name of the parent hosted zone.
* `parent zone_id` – (Optional) Zone ID of the parent hosted zone.
* `parent_tags` – (Optional) Tags of the parent hosted zone.
* `parent_ttl` – (Optional) The TTL of the record created in the parent hosted zone.
* `soa` – (Optional) An optional map of attributes for a Start of Authority (SOA) record. An SOA record is normally managed transparently by Route 53. However, there are scenarios where a non-default configuration is desirable. Read the [AWS documentation on the start of authority (SOA) record](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/SOA-NSrecords.html#SOArecords).
* `tags` - (Optional) A mapping of tags to assign to the resource.

`soa`
----------

The optional `soa` map supports the following values, all of which are optional:

* `serial` – A serial number that you can optionally increment whenever you update a record in the hosted zone.
* `refresh` – A refresh time in seconds that secondary DNS servers wait before querying the primary DNS server's SOA record to check for changes.
* `retry` – The retry interval in seconds that a secondary server waits before retrying a failed zone transfer. Normally, the retry time is less than the refresh time.
* `expire` – The time in seconds that a secondary server will keep trying to complete a zone transfer
* `ttl` – The minimum time to live (TTL). This value helps define the length of time that recursive resolvers should cache the following responses from Route 53

Attributes Reference
--------------------

The following attributes are exported:

* `name` – The name of Route 53 zone.
* `name_servers` – List of name servers for this zone. 
* `soa_record ` – The Start of Authority (SOA) record, if the code specifies an SOA block.
* `vpc_id ` – The id of the Virtual Private Cloud if a `vpc` is specified; this is only true for private zones.
* `zone_id` – The id of the Route 53 zone.