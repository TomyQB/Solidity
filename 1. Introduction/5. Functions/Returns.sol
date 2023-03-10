pragma solidity >=0.7.0 <0.9.0;

contract Returns {
    //Funcion que nos devuelva un saludo
    function saludos() public returns (string memory) {
        return "saludos";
    }

    //Esta funcion calcula el resultado de una multiplicacion de dos numeros enteros
    function Multiplicacion(uint256 _a, uint256 _b) public returns (uint256) {
        return _a * _b;
    }

    //Esta funcion devuelve true si el numero es par y false en caso contrario
    function par_impar(uint256 _a) public returns (bool) {
        bool flag;

        if (_a % 2 == 0) {
            flag = true;
        } else {
            flag = false;
        }

        return flag;
    }

    //Realizamos una funcion que nos devuelve el cociente y el residuo de una division
    // ademas de una variable booleana que es true si el residuo es 0 y false en caso contrario
    function division(uint256 _a, uint256 _b)
        public
        returns (
            uint256,
            uint256,
            bool
        )
    {
        uint256 q = _a / _b;
        uint256 r = _a % _b;
        bool multiplo = false;

        if (r == 0) {
            multiplo = true;
        }

        return (q, r, multiplo);
    }

    //Practica para el manejo de los valores devueltos

    function numeros()
        public
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (1, 2, 3, 4, 5, 6);
    }

    //Asignacion multiple

    function todos_los_valores() public {
        //Declaramos las variables donde se guardan los valores de retorno de la funcion numeros()
        uint256 a;
        uint256 b;
        uint256 c;
        uint256 d;
        uint256 e;
        uint256 f;
        //Realizar la asignacion multiple
        (a, b, c, d, e, f) = numeros();
    }

    function ultimo_valor() public {
        (, , , , , uint256 ultimo) = numeros();
    }
}
