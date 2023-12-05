using Ipet.API.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Ipet.API.Data
{
    public class ApplicationDbContext : IdentityDbContext<IdentityUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
                //options.UseMySql("server=mysql-banco-api.mysql.database.azure.com;initial catalog = IPET;uid=MysqlRoot;pwd=Mudar#123",
            options.UseMySql("server=164.152.244.159;initial catalog = ipet_mobile;uid=isaac;pwd=Isaacroque0209@;",
            Microsoft.EntityFrameworkCore.ServerVersion.Parse("8.0.0-mysql")).UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
        }
    } 
}
