Attribute VB_Name = "M�dulo1"
Option Explicit

Private cd As Selenium.ChromeDriver


Sub SendWhats()
    'Declara��o de vari�veis
    Dim cd As New Selenium.ChromeDriver
    Dim cxPesquisa As WebElement
    Dim cxMensagem As WebElement
    Dim localMsg As New Keys
    
    'Inicializa o ChromeDriver
    Set cd = New Selenium.ChromeDriver
    
'Tratamento de erro
On Error GoTo TratarErro

    With cd
        .SetBinary "C:\Program Files\Google\Chrome\Application\chrome.exe" 'Define o caminho para o execut�vel do Chrome
        .SetProfile Environ("LOCALAPPDATA") & "\Google\Chrome\User Data\Default" 'Define o caminho do perfil do Chrome onde a conta est� logada
        '.AddArgument "--remote-debugging-port=9222" 'Argumento para depura��o remota (permite reutilizar sess�es logadas)
        .AddArgument "--start-maximized" 'Inicia a janela maximizada
        .AddArgument "--hide-crash-restore-bubble" 'Evita que o Chrome exiba a mensagem de 'restaura��o de sess�o'
        .AddArgument "--disable-notifications" 'Desabilita as notifica��es do navegador
        .Start 'Inicia o Chrome
        .Get "https://web.whatsapp.com/" 'Acessa o WhatsApp Web
        .Wait 10000 'Espera de 10 segundos
    End With

    cd.Timeouts.PageLoad = 60000 'Tempo m�ximo para carregar a p�gina (60 segundos)
    cd.Timeouts.ImplicitWait = 60000 'Tempo m�ximo para localizar o elemento (60 segundos)
    
    'Declara a vari�vel do Timer
    Dim tempoInicial As Single
    tempoInicial = Timer
    Dim tempoLimite As Single
    tempoLimite = tempoInicial + 60 'Tempo m�ximo de 1 minuto

    'Loop para aguardar a p�gina ser carregada completamente
    Do While cxPesquisa Is Nothing And Timer < tempoLimite
        On Error Resume Next
        Set cxPesquisa = cd.FindElementByXPath("//*[@id=""side""]/div[1]/div/div[2]/div[2]/div/div/p")
        On Error GoTo 0
        cd.Wait 1000
    Loop

    'Restaura o tratamento normal
    On Error GoTo TratarErro

    If cxPesquisa Is Nothing Then
        MsgBox "N�o foi poss�vel carregar o WhatsApp. Tente novamente mais tarde.", vbCritical, "Erro de Carregamento"
        Exit Sub
    End If
    
    'Encontra o campo de pesquisa
    Set cxPesquisa = cd.FindElementByXPath("//*[@id=""side""]/div[1]/div/div[2]/div[2]/div/div/p")
    cxPesquisa.SendKeys "Saved Messages"
    cd.Wait 1000 'Espera

    'Pressiona Enter para selecionar o contato
    cxPesquisa.SendKeys localMsg.Enter
    cd.Wait 1000 'Espera

    'Localiza o campo de mensagem
    Set cxMensagem = cd.FindElementByXPath("//*[@id=""main""]/footer/div[1]/div/span/div/div[2]/div[1]/div/div[1]/p")
    
    'Envia a mensagem
    cxMensagem.SendKeys "Hello World!"
    cd.Wait 1000 'Espera

    'Pressiona Enter para enviar a mensagem
    cxMensagem.SendKeys localMsg.Enter
    cd.Wait 3000 'Espera
    
    'Mensagem de conex�o bem-sucedida no console
    Debug.Print "Conex�o estabelecida com sucesso!"
    
    Exit Sub 'Sai antes do tratamento de erros
    
TratarErro:
        Debug.Print "Erro inesperado: " & Err.Description & " (" & Err.Number & ")"
        MsgBox "Erro inesperado: " & Err.Description & " (" & Err.Number & ")", vbCritical, "Erro de Conex�o"
    
End Sub
