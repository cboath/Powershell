Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="My First Form" Height="480" Width="640">
    <Canvas>
      <Label Name="Label1" Content="Howdy!" HorizontalAlignment="Left" Height="27"
             Margin="23,10,0,0" VerticalAlignment="Top" Width="152" FontWeight="Bold" FontSize="14"/>

        <Button Name="Button1" Content="Click Here" HorizontalAlignment="Left" Height="39" Margin="65,201,0,0" VerticalAlignment="Top" Width="128" ClickMode="Press" Opacity="0.5">
            <Button.Effect>
                <DropShadowEffect/>
            </Button.Effect>
        </Button>

        <TextBox Name="TextBox1" HorizontalAlignment="Left" VerticalAlignment="Top" Height="165" Width="497" Margin="10,144,0,0"
                 TextWrapping="Wrap" Text="Enter Text" FontWeight="Bold" SpellCheck.IsEnabled="True" MaxLines="6" MaxLength="200" />

        <ListBox Name="ListBox1" HorizontalAlignment="Left" Height="24" Margin="175,42,0,0" VerticalAlignment="Top" Width="175">
            <ListBoxItem Content="First" />
            <ListBoxItem Content="Second" />
        </ListBox>

        <TextBlock HorizontalAlignment="Left" Height="111" Margin="46,35,0,0" TextWrapping="Wrap" VerticalAlignment="Top"
                   Width="117" Text="There is a whole lot of garbage I could put in here but I am not going to." />

    </Canvas>
    </Window>
"@

$NR=(New-Object System.Xml.XmlNodeReader $Form)
$Win=[Windows.Markup.XamlReader]::Load( $NR )

$Win.Showdialog()