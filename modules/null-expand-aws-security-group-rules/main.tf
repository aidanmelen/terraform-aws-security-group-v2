locals {
  rules = {
    for rule in flatten(concat(
      [
        for _rule in var.rules : [
          for cidr_block in try(_rule.cidr_blocks, []) : merge(
            try(_rule.description != null ? { description = _rule.description } : {}, {}),
            {
              type        = _rule.type
              rule        = try(_rule.rule, null)
              from_port   = try(_rule.from_port, null)
              to_port     = try(_rule.to_port, null)
              protocol    = try(_rule.protocol, null)
              cidr_blocks = [cidr_block]
            }
          )
          if try(contains(keys(_rule), "cidr_blocks"), false)
        ]
      ],
      [
        for _rule in var.rules : [
          for ipv6_cidr_block in try(_rule.ipv6_cidr_blocks, []) : merge(
            try({ description = _rule.description }, {}),
            {
              type             = _rule.type
              rule             = try(_rule.rule, null)
              from_port        = try(_rule.from_port, null)
              to_port          = try(_rule.to_port, null)
              protocol         = try(_rule.protocol, null)
              ipv6_cidr_blocks = [ipv6_cidr_block]
            }
          )
          if try(contains(keys(_rule), "ipv6_cidr_blocks"), false)
        ]
      ],
      [
        for _rule in var.rules : [
          for prefix_list_id in try(_rule.prefix_list_ids, []) : merge(
            try({ description = _rule.description }, {}),
            {
              type            = _rule.type
              rule            = try(_rule.rule, null)
              from_port       = try(_rule.from_port, null)
              to_port         = try(_rule.to_port, null)
              protocol        = try(_rule.protocol, null)
              prefix_list_ids = [prefix_list_id]
            }
          )
          if try(contains(keys(_rule), "prefix_list_ids"), false)
        ]
      ],
      [
        for _rule in var.rules : merge(
          try({ description = _rule.description }, {}),
          {
            type                     = _rule.type
            rule                     = try(_rule.rule, null)
            from_port                = try(_rule.from_port, null)
            to_port                  = try(_rule.to_port, null)
            protocol                 = try(_rule.protocol, null)
            source_security_group_id = _rule.source_security_group_id
          }
        )
        if try(contains(keys(_rule), "source_security_group_id"), false)
      ],
      [
        for _rule in var.rules : merge(
          try({ description = _rule.description }, {}),
          {
            type      = _rule.type
            rule      = try(_rule.rule, null)
            from_port = try(_rule.from_port, null)
            to_port   = try(_rule.to_port, null)
            protocol  = try(_rule.protocol, null)
            self      = _rule.self
          }
        )
        if try(contains(keys(_rule), "self"), false)
      ],
      )) : lower(join("-", compact([
        try(rule.type, null),
        try(rule.rule, null),
        try(rule.from_port, null),
        try(rule.to_port, null),
        try(rule.protocol, null),
        try(join("-", rule.cidr_blocks), null),
        try(join("-", rule.ipv6_cidr_blocks), null),
        try(join("-", rule.prefix_list_ids), null),
        try(rule.source_security_group_id, null),
        try(rule.self, null),
    ]))) => rule if var.create
  }
}
