function docker {

    param($Command)

    switch ($Command) {

        "inspect" { "running" }

        "ps" { "" }

        default { "" }

    }

}