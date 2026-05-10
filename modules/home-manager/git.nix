{ pkgs, ... }: {
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "Bruno Flávio Ferreira";
                email = "him@brunoflaviof.com";
            };
        };
    };
}
