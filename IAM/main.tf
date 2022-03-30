# I am creating dev users
resource "aws_iam_user" "dev-user1" {
  name = "John"
}

resource "aws_iam_user" "dev-user2" {
  name = "Tom"
}

# I am creating IAM group
resource "aws_iam_group" "developers" {
  name = "developers"
}

# I am trying to add users to group
resource "aws_iam_group_membership" "developers-attachment" {
  name = "attaching-users-to-group"

  users = [
    aws_iam_user.dev-user1.name,
    aws_iam_user.dev-user2.name,
  ]

  group = aws_iam_group.developers.name
}

# Policy attachment to group
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-policy"
  groups     = [aws_iam_group.developers.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
