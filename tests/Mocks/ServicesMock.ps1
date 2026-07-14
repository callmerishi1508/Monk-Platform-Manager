function Get-MonkServices {

    @(
        [PSCustomObject]@{
            Name="qdrant"
            Container="qdrant"
        }

        [PSCustomObject]@{
            Name="redis"
            Container="redis"
        }
    )

}