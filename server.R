

options(shiny.maxRequestSize = 9*1024^2)

function(input, output, session) {

  
  observeEvent(input$Next, {
        newtab <- switch (input$Next, 
                  "complain"= "protocol")
                  updateTabItems(session, "tabs", newtab )
              })
  
  
  
  

  output$Temperaturverlauf1 <- renderPlot ({
    temp.max = 130

    x = seq(-100, 100, 0.1)
    y = df(x, 10, 10)
    y = dbeta(x, 2, 5)
    y = dnorm(x, 40, 10)
    y.max = which(y==max(y))
    alpha = temp.max / y[y.max]
    y2 = y * alpha
    plot(x + beta, y2, type="l", axes=FALSE, xlim=c(0, 80), ylim=c(0, 150), xlab= "Time (min)", ylab= "Temp(C)", cex.lab= 1.5)


  })
  
   
  output$Temperatureprotocol <- renderPlot ({
    
    temp.max = input$temp.max
    dauer100 = input$dauer100
    

    x = seq(-100, 100, 0.1)
    y = df(x, 10, 10)
    y = dbeta(x, 2, 5)
    D = seq(0.5, 50, 0.5)
    
    dauer = 0
    if (temp.max > 100) {
      for (i in 1:100) {
        y = dnorm(x, 40, D[i])
        y.max = which(y==max(y))
        alpha = temp.max / y[y.max]
        y2 = y * alpha
        index100 = which(y2>=100)
        dauer = max(x[index100]) - min(x[index100])
        if (dauer>dauer100) break
      }
    }
    if (temp.max <= 100) {
      y = dnorm(x, 40, 10)
      y.max = which(y==max(y))
      alpha = temp.max / y[y.max]
      y2 = y * alpha
      index100 = which(y2>=100)
    }
    
    
    
    beta = 0
    if (length(index100)>0) beta = (40-x[index100[1]])  ### Beta verschiebt den Graph so, dass Maximaltemp bei 40min liegt
    
    plot(x + beta, y2, type="l", axes=FALSE, xlim=c(0, 80), ylim=c(0, 150), xlab= "Time (min)", ylab= "Temp(C)", cex.axis= 2)
    if (length(index100)>0) polygon(x[c(index100, index100[length(index100)])]+beta, y2[c(index100, index100[1])], col="red", density=12)
    axis(1, seq(0, 80, 10), seq(0, 80, 10))
    axis(2)
    box()
    
    F = 0
    
    
    
    if (length(index100)>0) {
      xF = x[index100]
      xFminutes = xF[1]
      count = 1
      while (max(xFminutes)<max(xF)) {
        xFminutes[count +1] = xF[1] + count
        count = count + 1
      }
      yFminutes = y2[match(xFminutes, x)]
      xFminutes = xFminutes[1:(length(xFminutes)-1)]
      yFminutes = yFminutes[1:(length(yFminutes)-1)]
     
      
      tabC = c(seq(100, 109, 0.5), seq(110, 119, 0.5), seq(120, 129, 0.5))
      #tabF = seq(0.008, 6.15, length.out=length(tabC))
      tabF = c(0.008, 0.009, 0.010, 0.011,0.012, 0.014, 0.015, 0.017, 0.019, 0.022, 0.024, 0.027, 0.031, 0.035, 0.039, 0.044, 0.049, 0.055, 0.062, 0.077, 0.087, 0.097, 0.109, 0.123, 0.138, 0.154,0.173, 0.194, 0.219, 0.245, 0.275, 0.308, 0.346, 0.388, 0.436, 0.489, 0.548, 0.615, 0.775, 0.800, 0.975, 1.377, 1.227, 1.377, 1.545, 1.733, 1.944, 2.182, 2.448, 2.746, 3.082, 3.458, 3.880, 4.354, 4.885, 5.482, 6.150)
      tab = cbind(tabC, tabF)
      
      indextab = rep(NA, length(yFminutes))
      for (i in 1:length(yFminutes)) indextab[i] = max(which(tabC<=yFminutes[i]))
      
      F = round(sum(tab[indextab,2]), digits=2)
      zeit100 = round(xFminutes[length(xFminutes)] - xFminutes[1], 1)
      text(7, 140, paste(zeit100, "min above 100\u00B0C: "), cex=1.4, col= "red")
    

      }
     

    observeEvent (input$temp.max, {
      if (temp.max>100){
        output$ftext <- renderText({paste("F-value:")})
        output$fwert <- renderText ({paste(F)})
      }
    } )
    
    output$instruction <- renderText ({"Please select the maximal core temperature in the food can and the minutes above 100\u00B0C."})
  
    output$ftext2 <- renderText ({("Der F-Wert ist eine Ma\u00DFzahl f\u00FCr die Hitzeeinwirkung, der eine Konserve ausgesetzt war. Dieser Wert ist vom Leitkeim abh\u00E4ngig. In diesem Fall handelt es sich um Cl. sporogenes.
                                   ")})
   
     
     observeEvent (input$ask, {
       if ((input$ask=="Kesselkonserve")&& (F> 0.39) && (F<0.59)) {
         
         output$itext <- renderText ({""})
         output$correct <- renderText ({"Correct. Acoording to the heating protocol you achieved a short durability food can."})
         output$textf <- renderText ({""})
       }
       
       if ((input$ask=="Kesselkonserve")&& (F> 0.6)) {
         
         output$itext <- renderText ({"Almost correct... you already achieved a short durability food can, but the temperature is unnecessary high. The higher the temperature, the more ingredients get overcooked!"})
         output$correct <- renderText ({""})
         output$textf <- renderText ({""})
       }
       
       else if ((input$ask=="Kesselkonserve")&& (F<0.4)){
         output$itext <-renderText ({""})
         output$correct <- renderText ({""})
         output$textf <- renderText ({"Incorrect. The heating is not enough to achieve a short durability food can."})
         
       }
       
     })
    
  
  observeEvent (input$ask, {
    if ( input$ask =="" ){
      output$itext <-renderText ({""})
      output$correct <- renderText ({""})
      output$textf <- renderText ({""})
    
  
    }
  
  }  
  )
   
   observeEvent (input$ask, {
      if ((input$ask=="3/4 Konserve")&& (F<= 0.8) && (F>=0.6)) {
      
        output$itext <- renderText ({""})
        output$correct <- renderText ({"Correct. Acoording to the heating protocol you achieved a middle term durability food can."})
        output$textf <- renderText ({""})
      }
     
     if ((input$ask=="3/4 Konserve")&& (F> 0.8)) {
       
       output$itext <- renderText ({"Almost correct... you already achieved a middle term durability food can, but the temperature is unnecessary high. The higher the temperature, the more ingredients get overcooked!"})
       output$correct <- renderText ({""})
       output$textf <- renderText ({""})
     }
     
     else if ((input$ask=="3/4 Konserve")&& (F<0.6)){
       output$itext <-renderText ({""})
       output$correct <- renderText ({""})
       output$textf <- renderText ({"Incorrect. The heating is not enough to achieve a middle term durability food can."})
       
     }

   })

  

   observeEvent (input$ask, {
     if ((input$ask=="Vollkonserve")&& (F >=4) && (F<=5.5)) {
       
       output$itext <- renderText ({""})
       output$correct <- renderText ({"Correct. Acoording to the heating protocol you achieved a fully preserved food can."})
       output$textf <- renderText ({""})
       
     }
     
     if ((input$ask=="Vollkonserve")&& (F>5.5)){
       output$itext <- renderText ({"Almost correct... you already achieved a fully preserved food can, but the temperature is unnecessary high. The higher the temperature, the more ingredients get overcooked! "})
       output$correct <- renderText ({""})
       output$textf <- renderText ({""})
     }
     else if ((input$ask=="Vollkonserve")&& (F<4)){
       output$itext <-renderText ({""})
       output$correct <- renderText ({""})
       output$textf <- renderText ({"Incorrect. The heating is not enough to achieve a fully preserved food can."})
     
       }
   }
   )
   
   observeEvent (input$ask, {
     if ((input$ask=="Tropenkonserve")&& (F >=12) & (F <=20)) {
       output$correct <- renderText ({"Correct. Acoording to the heating protocol you achieved a tropical food can."})
       output$textf <- renderText ({""})
        output$itext <- renderText ({""})
       }
     
     if ((input$ask=="Tropenkonserve")&& (F <12)) {
       output$correct <- renderText ({""})
       output$textf <- renderText ({"Incorrect. The heating is not enough to achieve a tropical food can."})
       output$itext <- renderText ({""})
       }
       
     else if ((input$ask=="Tropenkonserve")&& (F >20)){
       output$correct <- renderText ({""})
    
       output$correct <- renderText ({""})
       output$itext <- renderText ({"Almost correct... you already achieved a tropical food can, but the temperature is unnecessary high. The higher the temperature, the more ingredients get overcooked! "})
       output$textf <- renderText ({""})
       }
   }
   )

  })




  observeEvent( input$temp.max, {
    if (input$temp.max>121){
      
      showNotification(type ="error", id="warning",
        HTML(
        paste(h3("Attention:"), sep="\n" ,
                             h4("only raise if necessary."), 
                        h4("Ingredients get seriously damaged above 121\u00B0C!")
                              )))
    }
  }
    
  )

  observeEvent( input$temp.max, {
    if (input$temp.max<121){

      removeNotification("warning")
    }
  }

  )
  


  
  
  
  

  
  
  
  

  
  
}