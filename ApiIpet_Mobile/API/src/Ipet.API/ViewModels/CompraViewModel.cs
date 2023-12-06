using System.ComponentModel.DataAnnotations;

namespace Ipet.Api.ViewModels
{
    public class CompraViewModel
    {
        [Key]
        public Guid Id { get; set; }

        [Required(ErrorMessage = "O campo UsuarioId é obrigatório.")]
        public Guid UsuarioId { get; set; }

        [Required(ErrorMessage = "O campo Nome é obrigatorio")]
        public int Qtde { get; set; }

        [Required(ErrorMessage = "O campo Valor é obrigatório.")]
        public float Valor { get; set; }

    }
}
