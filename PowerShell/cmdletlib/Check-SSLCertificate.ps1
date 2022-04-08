#!/usr/bin/env pwsh

$code = @"
using System;
using System.Net;
using System.Net.Http;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace PatrykAdamczykCmdLetLib
{
	public class CheckSSLCertificate
	{
		public static void Main(string Address){
            var handler = new HttpClientHandler();
            handler.ServerCertificateCustomValidationCallback = (
                HttpRequestMessage message,
                X509Certificate2 certificate2,
                X509Chain certchain,
                SslPolicyErrors policyerrors
            ) =>
            {
                var certExpDate = certificate2.NotAfter;
                int certExpiresIn = (certExpDate - DateTime.Now).Days;
                var certName = certificate2.Subject;
                var certThumbprint = certificate2.GetCertHashString();
                var certEffectiveDate = certificate2.GetEffectiveDateString();
                var certIssuer = certificate2.Issuer;
                if (certExpiresIn > 30)
                {
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine($"The {Address} certificate expires in {certExpiresIn} days [{certExpDate}]");
                    Console.ResetColor();
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine($"The {Address} certificate expires in {certExpiresIn} days [{certExpDate}]");
                    Console.ResetColor();
                }
                Console.WriteLine("Details:");
                var padding = "  ";
                Console.WriteLine($"{padding}Cert name: {certName}");
                Console.WriteLine($"{padding}Cert thumbprint: {certThumbprint}");
                Console.WriteLine($"{padding}Cert effective date: {certEffectiveDate}");
                Console.WriteLine($"{padding}Cert issuer: {certIssuer}");
                return true;
            };
            var req = new System.Net.Http.HttpClient(handler);
            req.Timeout = TimeSpan.FromMilliseconds(10000);
            var res = req.GetAsync(Address).Result;
		}
	}
}
"@
Add-Type -TypeDefinition $code -Language CSharp -ErrorAction SilentlyContinue

function Check-SSLCertificate (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $Address
) {
    # Writing this through C# directly because PowerShell is fucked
    [PatrykAdamczykCmdLetLib.CheckSSLCertificate]::Main($Address)
}

Write-Host -ForegroundColor DarkRed "Warning! Check-SSLCertificate is added only once as type. Changes of it after reloading of profile file will not apply to same session!";
