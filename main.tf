provider "aws" {
  region = "eu-central-1"
}

module "inst1" {
  source = "./inst1"
  /*name = "${module.inst2.depend_name}"*/
  name = "nondepend-inst"
}

module "inst2" {
  source = "./inst2"
  name = "main-inst"
  dependency_name = "depend-inst"
}
