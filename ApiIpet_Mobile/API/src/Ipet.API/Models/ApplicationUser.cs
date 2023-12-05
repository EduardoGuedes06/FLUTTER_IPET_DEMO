using Microsoft.AspNetCore.Identity;

namespace Ipet.API.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string Nome { get; set; }
        public string Imagem { get; set; }
        public string Cep { get; set; }
        public string Numero { get; set; }
        public string Password { get; set; }
        public string ConfirmPassord { get; set; }
        public string Documento { get; set; }
    }
}
