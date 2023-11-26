terraform {
  cloud {
    organization = "TickleThePanda"

    workspaces {
      name = "auth"
    }
  }
}
