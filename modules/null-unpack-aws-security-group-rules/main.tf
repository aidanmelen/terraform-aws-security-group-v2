locals {
  rules = {
    for rule in flatten(concat(
      [
        for _rule in var.rules : [
          for cidr_block in try(_rule.cidr_blocks, []) : merge(
            try({ description = _rule.description }, {}),
            try({ rule = _rule.rule }, {}),
            try({ from_port = _rule.from_port }, {}),
            try({ to_port = _rule.to_port }, {}),
            try({ protocol = _rule.protocol }, {}),
            { cidr_blocks = [cidr_block] }
          )
          if try(contains(keys(_rule), "cidr_blocks"), false)
        ]
      ],
      [
        for _rule in var.rules : [
          for ipv6_cidr_block in try(_rule.ipv6_cidr_blocks, []) : merge(
            try({ description = _rule.description }, {}),
            try({ rule = _rule.rule }, {}),
            try({ from_port = _rule.from_port }, {}),
            try({ to_port = _rule.to_port }, {}),
            try({ protocol = _rule.protocol }, {}),
            { ipv6_cidr_blocks = [ipv6_cidr_block] }
          )
          if try(contains(keys(_rule), "ipv6_cidr_blocks"), false)
        ]
      ],
      [
        for _rule in var.rules : [
          for prefix_list_id in try(_rule.prefix_list_ids, []) : merge(
            try({ description = _rule.description }, {}),
            try({ rule = _rule.rule }, {}),
            try({ from_port = _rule.from_port }, {}),
            try({ to_port = _rule.to_port }, {}),
            try({ protocol = _rule.protocol }, {}),
            { prefix_list_ids = [prefix_list_id] }
          )
          if try(contains(keys(_rule), "prefix_list_ids"), false)
        ]
      ],
      [
        for _rule in var.rules : merge(
          try({ description = _rule.description }, {}),
          try({ rule = _rule.rule }, {}),
          try({ from_port = _rule.from_port }, {}),
          try({ to_port = _rule.to_port }, {}),
          try({ protocol = _rule.protocol }, {}),
          { self = _rule.self }
        )
        if try(contains(keys(_rule), "self"), false)
      ],
      [
        for _rule in var.rules : merge(
          try({ description = _rule.description }, {}),
          try({ rule = _rule.rule }, {}),
          try({ from_port = _rule.from_port }, {}),
          try({ to_port = _rule.to_port }, {}),
          try({ protocol = _rule.protocol }, {}),
          { source_security_group_id = _rule.source_security_group_id }
        )
        if try(contains(keys(_rule), "source_security_group_id"), false)
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
        try(rule.self, null),
        try(rule.source_security_group_id, null),
    ]))) => rule if var.create
  }
}
