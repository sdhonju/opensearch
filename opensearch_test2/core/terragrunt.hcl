  terraform {
        source = "../opensearch_main"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
