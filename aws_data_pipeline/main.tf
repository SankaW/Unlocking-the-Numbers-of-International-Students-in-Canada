################ Register application ######################

# Register application
resource "aws_servicecatalogappregistry_application" "Canada_Study_Permit_Data_Pipeline" {
  name        = "Canada_Study_Permit_Data_Pipeline"
  description = "Register Canada Study Permit Data Pipeline with the AWS cloud account"
}