provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_key_pair" "auth0-jobtest" {
  key_name = "auth0-jobtest"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGJCvWqX57o6U7OvwV3l7J9zAu529K4TqDnok+uvdtI4F8in4hKu69kPD/4nc25NIzLaTFJqL13mI0Lq3fhGtHJ+pe5qaiWQLszle6WQRsqxI/zpCB7C/bSQEclOAmjorpJysKa7GeEjXgRmiv7sCoQDDCHkLRqjTkKaB1iJaRAiLf1yhdGR+BMGtt/PggJW1e0J3Yc2WQDBuSE2b+oNJ311kKHDYDGh4lNHNgCCuzTuuGLy0SNzhCOihLaYNj/56y/m6pKp09fdBDrQDyw+7/iY1DUx3lImPyIXfGhdaW6TRPURI5PXfmcygbOrh32Fdi4OrNpJsiA+OwoXkM2lmt dominis@tinker"
}
