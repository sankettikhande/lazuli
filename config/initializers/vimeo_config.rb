$consumer_key = "900771423100758042765dca7983c3ab144c96c0"
$consumer_secret = "f90796328c1cd6f072d6a027eca9b6af07acd49b"

$access_token = "fb30379b2b50b751306ef4be6ef16471"
$access_secret_token = "da16ee3b990efd301758f067c5a21175456d94c0"


video = Vimeo::Advanced::Video.new($consumer_key, $consumer_secret, :token => $access_token, :secret => $access_secret_token)