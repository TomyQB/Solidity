pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Require {
    // Funcion que verfique la contraseña
    function password(string calldata _password)
        external
        pure
        returns (string memory)
    {
        require(
            keccak256(abi.encodePacked(_password)) ==
                keccak256(abi.encodePacked("12345")),
            "Contraseña incorrecta"
        );
        return "Contraseña correcta";
    }

    // Funcion para pagar
    uint256 tiempo = 0;
    uint256 public cartera = 0;

    function pagar(uint256 _cantidad) external returns (uint256) {
        require(now > tiempo + 5 seconds, "Aun no puedes pagar");
        tiempo = now;
        cartera += _cantidad;
        return cartera;
    }

    // Funcion con una lista
    string[] nombres;

    function nuevoNombre(string calldata _nombre) external {
        for (uint256 i = 0; i < nombres.length; i++) {
            require(
                keccak256(abi.encodePacked(_nombre)) !=
                    keccak256(abi.encodePacked(nombres[i])),
                "Ya está en la lista"
            );
        }
        nombres.push(_nombre);
    }
}
