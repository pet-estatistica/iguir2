template <- function(title) {
    ##-------------------------------------------
    ## Cria estilo iguir para as tags utilizadas no template
    cat("
<head>
<style>

table.iguir {
    margin-left: auto;
    margin-right: auto;
    margin-top: 1em;
    margin-bottom: 1em;
    background-color: rgba(0, 0, 0, 0);
    border: none;
    border-top: 4px solid #A96CBA;
    border-bottom: 4px solid #A96CBA;
    border-left: 0px;
    border-right: 0px;
    border-collapse: collapse;
    width: 80%;
}

td.iguir {
    border-bottom: 0px;
    border-top: 0px;
    border-left: 0px;
    border-right: 0px;
    padding-left: 20px;
    padding-right: 20px;
    padding-top: 10px;
    padding-bottom: 10px;
    background-color: rgba(0, 0, 0, 0);
}

h1.iguir {
    color: black;
    background-color: rgba(0, 0, 0, 0);
    font-weight: bold; 
    font-size: 1.8em; 
    font-family: Ubuntu;
}

h2.iguir {
    color: rgba(83, 83, 83, 0.8);
    background-color: rgba(0, 0, 0, 0);
    font-weight: bold; 
    font-size: 1.5em; 
    font-family: Ubuntu;
}

</style>
</head>", "

<table class = 'iguir'>
   <td class = 'iguir'> 
       <h1 class = 'iguir'>
       Interactive Graphical User Interface with R - IGUIR
       </h1>
       <h2 class = 'iguir'>", "", "
       </h2>
   </td>
   <td class = 'iguir' align='right'> 
       <img src = 'http://200.17.213.89/~iguir/iguir2.svg' height = '96' width = '96'> </img> 
   </td>  
</table>", sep = "\n")
}

