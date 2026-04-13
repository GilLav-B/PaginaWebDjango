{
  description = "Entorno Curso ProgWeb";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Backend & Frontend
          python312
          python312Packages.pip
          python312Packages.django
          nodejs_20
          nodePackages.yarn

          # Infraestructura
          postgresql_15
          redis

          # Herramientas
          tree        # <--- Agregado para que funcione el comando tree
          tmux 
          neovim 
          git 
          curl
        ];

        shellHook = ''
          # 1. Configuración de Python Virtualenv
          if [ ! -d ".venv" ]; then
            echo "Creando entorno virtual .venv..."
            python -m venv .venv
          fi
          source .venv/bin/activate

          # 2. Configuración de Postgres Local
          export PGDATA="$PWD/.postgres_data"
          export PGHOST="/tmp"

          # Inicialización automática de BD si no existe
          if [ ! -d "$PGDATA" ]; then
            echo "Inicializando base de datos en $PGDATA..."
            initdb --auth=trust --no-locale --encoding=UTF8 > /dev/null
          fi

          # Alias de ayuda
          alias db-start="pg_ctl start -l $PGDATA/logfile -o '-k /tmp'"
          alias db-stop="pg_ctl stop"

          # Limpiar pantalla y mostrar info
          clear
          echo "----------------------------------------"
          echo "   --- Entorno de ProgWeb activo ---"
          echo "----------------------------------------"
          echo "Python:     $(python --version)"
          echo "Postgres:   $(postgres --version)"
          echo "Ubicación:  $(pwd)"
          echo "----------------------------------------"
          echo "Comandos útiles:"
          echo "  db-start -> Inicia PostgreSQL"
          echo "  db-stop  -> Detiene PostgreSQL"
          echo "  tree     -> Visualiza la estructura de carpetas"
          echo "----------------------------------------"
        '';
      };
    };
}
