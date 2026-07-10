resource "aws_iam_policy" "fluent_bit_cloudwatch" {
  name = "FluentBitCloudWatchPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup", // creates a log folder
          "logs:CreateLogStream", // crates a log file inside the folder
          "logs:PutLogEvents", // writes log events to the log file
          "logs:DescribeLogStreams" // describes and checks what files are there to avoid duplicates and others
        ]
        Resource = "*" // any log group, tradeoff between security and convenience, but this is a demo so we are not too concerned about security
      }
    ]
  })
}

// oidc or servicee account or irsa setup here because it's relatively low stakes, just writing to logs
// unlike loadbalancers which have much more powerful permissions, so we can just attach the policy to the node group role instead of creating a new service account and role for it
resource "aws_iam_role_policy_attachment" "fluent_bit_attachment" {
  policy_arn = aws_iam_policy.fluent_bit_cloudwatch.arn
  role       = module.eks.eks_managed_node_groups["app_nodes"].iam_role_name
}