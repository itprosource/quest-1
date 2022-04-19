/*
resource "aws_secretsmanager_secret" "secret_word" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "secret_word_version" {
  secret_id     = aws_secretsmanager_secret.secret_word.id
  secret_string = var.secret_word
}
*/