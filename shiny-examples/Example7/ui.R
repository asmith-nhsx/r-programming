fluidPage(
    h1("Star wars"),
    div(
        div(
            h4("Episode IV: A NEW HOPE"),
            p("It is a period of civil war. Rebel spaceships, striking from a hidden base, have won their first victory against the evil Galactic Empire."),
            p("During the battle, Rebel spies managed to steal secret plans to the Empire's ultimate weapon, the DEATH STAR, an armored space station with enough power to destroy an entire planet."),
            p("Pursued by the Empire's sinister agents, Princess Leia races home aboard her starship, custodian of the stolen plans that can save her people and restore freedom to the galaxy...."),
            style="transform:rotateX(25deg); text-align: center; color:yellow; font-size: 150%; width:75%; display: inline-block;"
        ),
        style=" perspective: 250px; perspective-origin: 50% 50%; background-color: black; text-align:center;"
    ),
    h1("Custom HTML"),
    HTML("<p>This is a paragraph on its own.</p>")
)
