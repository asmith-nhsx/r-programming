# R-programming Week 1

3 + (4/5)
(3+4)/5
27^(1/3)


n <- 20                                # term of the loan
loan <- 9000                           # amount
interest.rate <- 0.15                  # effective annual interest rate
v <- 1 / (1+interest.rate)             # effective annual discount factor
payment <- loan * (1-v) / (v*(1-v^n))  # yearly payments
payment


k <- 10                                # year of repayment
alpha.k = v^(n+1-k)                    # capital factor 
capital.repayment <- payment * alpha.k
interest.repayment <- payment * (1-alpha.k)
capital.repayment
interest.repayment


k <- 1:n                               # create vector with all possible k
alpha <- v^(n+1-k)                     # split factors
capital <- alpha * payment             # capital repayments
interest <- (1-alpha) * payment        # interest part
data <- data.frame(Year=1:20, rbind(data.frame(Type="Capital repayment",
                                               Payment=capital),
                                    data.frame(Type="Interest",
                                               Payment=interest)))
library(ggplot2)
ggplot(data=data) + geom_col(aes(Year, Payment, fill=Type))

repayment <- function(n, loan, interest.rate) { 
  v <- 1 / (1+interest.rate)             # effective annual discount factor
  payment <- loan * (1-v) / (v*(1-v^n))  # yearly payments
  return(payment)                        # Return the answer
}

repayment(n=20, loan=9000, interest.rate=0.05)
repayment(n=20, loan=9000, interest.rate=0.10)
repayment(n=20, loan=9000, interest.rate=0.15)


