pragma solidity >=0.7.0 <0.9.0;

contract Arrays {
    //Array de enteros de longitud fija 5
    uint256[5] public array_enteros = [1, 2, 3];

    //Array de enteros de 32 bits de longitud fija con 7 posiciones
    uint32[7] array_enteros_32_bits;

    //Array de strings de longitud fija 15
    string[15] arra_strings;

    //Array dinamico de enteros
    uint256[] public array_dinamico_enteros;

    struct Persona {
        string nombre;
        uint256 edad;
    }

    //Array dinámico de tipo Persona
    Persona[] public array_dinamico_personas;

    function modificar_array() public {
        array_dinamico_enteros.push(3);
        array_dinamico_personas.push(Persona("hola", 3));
        array_enteros[2] = 56;
    }

    uint256 public test = array_enteros[2];
}
