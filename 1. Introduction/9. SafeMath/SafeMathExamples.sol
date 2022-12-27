pragma solidity >=0.7.0 <0.9.0;
import "./SafeMath.sol";

contract SafeMathExamples {
    //Debemos declarar para que tipo de datos usaremos la libreria
    using SafeMath for uint256;

    //Funcion suma segura

    function suma(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.add(_b);
    }

    //Funcion resta
    function resta(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.sub(_b);
    }

    //funcion multiplicacion
    function multiplicacion(uint256 _a, uint256 _b)
        public
        pure
        returns (uint256)
    {
        return _a.mul(_b);
    }
}
