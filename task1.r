#############
# Task 1 d) #
#############

beta <- 0.05;
gamma <- 0.20;
N <- 1000;
N.realizations <- 1000;
T.s <- c(1:N);
T.i <- c(1:N);
p <- 0;
cur.state <- "S"

cat(sprintf("Starting simulation, simulating %i times\n\n--------------------\n\n", N));

for (i in 1:N) {
    if (!(i %% 100)) {
        cat(sprintf("Running simulation %i...\n", i));
    }

    t.s <- 1;
    t.i <- 1;

    p = runif(1);

    while (p > beta) {
        t.s <- t.s + 1;
        p <- runif(1);
    }
    
    p = runif(1);

    while (p > gamma) {
        t.i <- t.i + 1;
        p <- runif(1);
    }
    
    T.s[i] <- t.s;
    T.i[i] <- t.i;
}

cat(sprintf("\n----------------------\nSimulations complete!\n\n"));
cat(sprintf("Average time in state S: %f\n", mean(T.s)));
cat(sprintf("Average time in state I: %f\n", mean(T.i)));
cat(sprintf("Standard deviation of time in state S: %f\n", sd(T.s)));
cat(sprintf("Standard deviation of time in state I: %f\n", sd(T.i)));

#############
# Task 1 e) #
#############

require( tikzDevice );

tikz( 'problem1e.tex' , standAlone = TRUE);

beta <- function(I, tot) {
    return(0.5*I/tot);
}

S.0 <- 950;
I.0 <- 50;
R.0 <- 0;
S <- 1;
I <- 2;
R <- 3;
Y.0 <- c(S.0, I.0, R.0);
gamma <- 0.20;
tot <- 1000;
ns <- 3;
n <- 200;
N <- 1000;
Y <- matrix(c(Y.0, 1:(ns*(n - 1))), nrow = ns);
t.s <- 0;
t.i <- 0;
p <- 0;

cat(sprintf("Starting simulation, simulating %i time steps\n", n));

for (i in 2:n) {
    # Calculate number of people that gets sick
    dI = rbinom(1, Y[S, i - 1], beta(Y[I, i - 1], tot));
    # Calculate number of people that recovers
    dR = rbinom(1, Y[I, i - 1], gamma);
    # Update population
    Y[S, i] <- Y[S, i - 1] - dI;
    Y[I, i] <- Y[I, i - 1] + dI - dR;
    Y[R, i] <- Y[R, i - 1] + dR;
}

cat(sprintf("Simulations complete!\n"));
cat(sprintf("Final population distribution:\n\n"));

S <- Y[1,];
I <- Y[2,];
R <- Y[3,];
t <- c(1:n);

cat(sprintf("S: %f\nI: %f\nR: %f\nTotal: %f\n", S[length(S)], I[length(I)], R[length(R)], S[length(S)] + I[length(I)] + R[length(R)]));

plot(t, S, type='l', col='red', main = 'Evolution over time for $S$, $I$ and $R$', ylim=c(0, tot), ylab='Number of individuals', xlab='$n$', cex.lab=1.5, lwd = 3.5);
lines(t, I, type='l', col='green', lwd = 3.5);
lines(t, R, type='l', col='blue', lwd = 3.5);
grid(nx=4, ny=10, col='darkgrey');
legend(x=0.7*n, y=0.75*tot, legend=c('$S$', '$I$', '$R$'),
       col=c('red', 'green', 'blue'), lty=1:2, cex=1.5, bg='white', lwd = 3.5)
dev.off();

tools::texi2dvi('problem1e.tex',pdf=T);
system('xdg-open problem1e.pdf');

#############
# Task 1 f) #
#############

beta <- function(I, tot) {
    return(0.5*I/tot);
}

S.0 <- 950;
I.0 <- 50;
R.0 <- 0;
S <- 1;
I <- 2;
R <- 3;
Y.0 <- c(S.0, I.0, R.0);
gamma <- 0.20;
tot <- 1000;
ns <- 3;
n <- 200;
N <- 1000;
Y <- matrix(c(Y.0, 1:(ns*(n - 1))), nrow = ns);
I.max = c(1:N);
n.max = c(1:N);

cat(sprintf("Starting simulation, simulating %i time steps per simulation and %i simulations.\n", n, N));

for (j in 1:N) {

    for (i in 2:n) {
        # Calculate number of people that gets sick
        dI = rbinom(1, Y[S, i - 1], beta(Y[I, i - 1], tot));
        # Calculate number of people that recovers
        dR = rbinom(1, Y[I, i - 1], gamma);
        # Update population
        Y[S, i] <- Y[S, i - 1] - dI;
        Y[I, i] <- Y[I, i - 1] + dI - dR;
        Y[R, i] <- Y[R, i - 1] + dR;
    }

    I.max[j] <- max(Y[I,]);
    n.max[j] <- which.max(Y[I,]);
}

cat(sprintf("Simulations complete!\n"));
cat(sprintf("----------------------\nEstimated max of I: %f, rounded off: %i\n", mean(I.max), round(mean(I.max))));
cat(sprintf("Standard deviation max of I: %f, rounded off: %i\n", sd(I.max), round(sd(I.max))));
cat(sprintf("----------------------\nEstimated number of time steps before max I: %f, rounded off: %i\n", mean(n.max), round(mean(n.max))));
cat(sprintf("Standard deviation number of time steps before max I: %f, rounded off: %i\n--------------------------\n", sd(n.max), round(sd(n.max))));
