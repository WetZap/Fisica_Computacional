#define _USE_MATH_DEFINES
#include <stdio.h>
#include <math.h>

double serie(double theta);
unsigned long long factorial1(int n);

int main(void)
{
    double theta, thetapunto, thetadobpunt, t, omega, periodo;
    double g, h, l, pi, periodo_in;

    g = 9.8;
    h = 0.05;
    l = 1.0;
    pi = acos(-1.0);
    theta = pi / 4;
    thetapunto = 0;
    t = 0.0;
    h = 0.05;
    periodo_in = 2 * pi * sqrt(l / g);

    while (t < 10.0)
    {
        periodo = periodo_in * (1 + serie(theta));
        printf("%lf", serie(theta));
        thetadobpunt = -(g / l) * sin(theta);
        omega = thetapunto + (h / 2) * thetadobpunt;
        theta = theta + h * omega;
        thetadobpunt = -(g / l) * sin(theta);
        thetapunto = omega + h / 2 * thetadobpunt;

        // printf("Periodo %d", periodo / periodo_in, "\n");

        t += h;
    }
    return 0;
}

double serie(double theta)
{
    double valor, expresion;
    int n, i;
    valor = 0.0;
    n = 1000;

    for (i = 1; i < n; i++)
    {
        expresion = (pow(((factorial1(2 * i)) / ((pow(2, 2 * i)) * (pow((factorial1(i)), 2)))), 2)) * pow((sin(theta / 2)), (2 * i));
        printf("%lf", valor);
        valor += expresion;
    }
    return valor;
}
unsigned long long factorial1(int n)
{
    if (n <= 1)
        return 1;
    return n * factorial1(n - 1);
}