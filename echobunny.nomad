  job "echobunny" {
    type        = "batch"
    datacenters = ["alpha"]

    meta {
      input   = ""
      profile = "small"
    }

    # The new "parameterized" stanza that marks a job as dispatchable. In this
    # example, there are two pieces of metadata (see above). The "input"
    # parameter is required, but the "profile" parameter is optional and defaults
    # to "small" if left unspecified when dispatching the job.
    parameterized {
      meta_required = ["input"]
      meta_optional = ["profile"]
    }

    task "echoer" {
      driver = "docker"
      leader = true

      config {
        image        = "veverkap/filewriter:77fd38b"
        network_mode = "bridge"
        args         = ["${NOMAD_META_INPUT}", "${NOMAD_META_PROFILE}"]
      }

      resources {
        cpu    = 1000
        memory = 256
      }
    }
  }
