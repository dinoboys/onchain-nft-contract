// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "../lib/base64.sol";
import "./ITokenDescriptor.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MusDescriptor is ITokenDescriptor {
    struct Color {
        string value;
        string name;
    }
    struct Trait {
        string content;
        string name;
        Color color;
    }
    using Strings for uint256;

    string private constant SVG_END_TAG = "</svg>";

    function tokenURI(
        uint256 tokenId,
        uint256 seed
    ) external pure override returns (string memory) {
        uint256[4] memory colors = [
            (seed % 100000000000000) / 1000000000000,
            (seed % 10000000000) / 100000000,
            (seed % 1000000) / 10000,
            seed % 100
        ];
        Trait memory head = getHead(seed / 100000000000000, colors[0]);
        Trait memory face = getFace(
            (seed % 1000000000000) / 10000000000,
            colors[1]
        );
        Trait memory body = getBody((seed % 100000000) / 1000000, colors[2]);
        Trait memory foot = getFoot((seed % 10000) / 100, colors[3]);
        string memory colorCount = calculateColorCount(colors);

        string memory rawSvg = string(
            abi.encodePacked(
                '<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="100%" height="100%" fill="#25314d"/>',
                '<text x="270" y="165" font-family="Ubuntu," font-weight="900" font-size="65" text-anchor="middle" letter-spacing="10">',
                '<animate attributeName="dy" values="50;0;0:0" dur="0.5s" repeatCount="indefinite" />',
                head.content,
                face.content,
                body.content,
                foot.content,
                "</text>",
                SVG_END_TAG
            )
        );

        string memory encodedSvg = Base64.encode(bytes(rawSvg));
        string
            memory description = "Robustus Mus is fully onchain NTFs, no IPFS or any external storage.  Olny code (x.+)";

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                "{",
                                '"name":"MUS #',
                                tokenId.toString(),
                                '",',
                                '"description":"',
                                description,
                                '",',
                                '"image": "',
                                "data:image/svg+xml;base64,",
                                encodedSvg,
                                '",',
                                '"attributes": [{"trait_type": "Head", "value": "',
                                head.name,
                                " (",
                                head.color.name,
                                ")",
                                '"},',
                                '{"trait_type": "Face", "value": "',
                                face.name,
                                " (",
                                face.color.name,
                                ")",
                                '"},',
                                '{"trait_type": "Body", "value": "',
                                body.name,
                                " (",
                                body.color.name,
                                ")",
                                '"},',
                                '{"trait_type": "Foot", "value": "',
                                foot.name,
                                " (",
                                foot.color.name,
                                ")",
                                '"},',
                                '{"trait_type": "Colors", "value": ',
                                colorCount,
                                "}",
                                "]",
                                "}"
                            )
                        )
                    )
                )
            );
    }

    function getColor(uint256 seed) private pure returns (Color memory) {
        if (seed == 10) {
            return Color("#e60049", "Hex e60049");
        }
        if (seed == 11) {
            return Color("#82b6b9", "Hex 82b6b9");
        }
        if (seed == 12) {
            return Color("#b3d4ff", "Hex b3d4ff");
        }
        if (seed == 13) {
            return Color("#00ffff", "Hex 00ffff");
        }
        if (seed == 14) {
            return Color("#0bb4ff", "Hex 0bb4ff");
        }
        if (seed == 15) {
            return Color("#1853ff", "Hex 1853ff");
        }
        if (seed == 16) {
            return Color("#35d435", "Hex 35d435");
        }
        if (seed == 17) {
            return Color("#61ff75", "Hex 61ff75");
        }
        if (seed == 18) {
            return Color("#00bfa0", "Hex 00bfa0");
        }
        if (seed == 19) {
            return Color("#ffa300", "Hex ffa300");
        }
        if (seed == 20) {
            return Color("#fd7f6f", "Hex fd7f6f");
        }
        if (seed == 21) {
            return Color("#d0f400", "Hex d0f400");
        }
        if (seed == 22) {
            return Color("#9b19f5", "Hex 9b19f5");
        }
        if (seed == 23) {
            return Color("#dc0ab4", "Hex dc0ab4");
        }
        if (seed == 24) {
            return Color("#f46a9b", "Hex f46a9b");
        }
        if (seed == 25) {
            return Color("#bd7ebe", "Hex bd7ebe");
        }
        if (seed == 26) {
            return Color("#fdCEe5", "Hex fdCEe5");
        }
        if (seed == 27) {
            return Color("#FCE74C", "Hex FCE74C");
        }
        if (seed == 28) {
            return Color("#eeeeee", "Hex eeeeee");
        }
        if (seed == 29) {
            return Color("#7f766d", "Hex 7f766d");
        }

        return Color("", "");
    }

    function getHead(
        uint256 seed,
        uint256 colorSeed
    ) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 10) {
            content = "(`)_(`)";
            name = "Flat";
        }
        if (seed == 11) {
            content = "(`)~(`)";
            name = "Curly Hair";
        }
        if (seed == 12) {
            content = "(`),,(`)";
            name = "Side Comb";
        }
        if (seed == 13) {
            content = "(`)//(`)";
            name = "Punk";
        }
        if (seed == 14) {
            content = "(`)+(`)";
            name = "Nurse";
        }
        if (seed == 15) {
            content = "(`)^(`)";
            name = "Cone Hat";
        }
        if (seed == 16) {
            content = "(`)o(`)";
            name = "Third Eye";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan fill="',
                        color.value,
                        '">',
                        content,
                        "</tspan>"
                    )
                ),
                name,
                color
            );
    }

    function getFace(
        uint256 seed,
        uint256 colorSeed
    ) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 10) {
            content = "=(o.o)=";
            name = "Eyes open";
        }
        if (seed == 11) {
            content = "=(-.-)=";
            name = "Sleeping";
        }
        if (seed == 12) {
            content = "=(o.-)=";
            name = "Wink";
        }
        if (seed == 13) {
            content = "=(o.O)=";
            name = "Suspicious";
        }
        if (seed == 14) {
            content = "=(^.^)=";
            name = "Smile";
        }
        if (seed == 15) {
            content = "=(x.x)=";
            name = "Dead Face";
        }
        if (seed == 16) {
            content = "=[=.=]=";
            name = "Robot";
        }
        if (seed == 16) {
            content = "=($.$)=";
            name = "Money-oriented";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan dy="65" x="270" fill="',
                        color.value,
                        '">',
                        content,
                        "</tspan>"
                    )
                ),
                name,
                color
            );
    }

    function getBody(
        uint256 seed,
        uint256 colorSeed
    ) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 10) {
            content = "o[ :-]o";
            name = "Feathers";
        }
        if (seed == 11) {
            content = "o(\\$/)o";
            name = "Swag";
        }
        if (seed == 12) {
            content = "o(=|=)o";
            name = "Muscular";
        }
        if (seed == 13) {
            content = "o(\\+/)o";
            name = "Priest";
        }
        if (seed == 14) {
            content = "o( :~)o";
            name = "Shirt";
        }
        if (seed == 15) {
            content = "o(\\:/)o";
            name = "Suit";
        }
        if (seed == 16) {
            content = "o(\\~/)o";
            name = "Tuxedo";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan dy="65" x="270" fill="',
                        color.value,
                        '">',
                        content,
                        "</tspan>"
                    )
                ),
                name,
                color
            );
    }

    function getFoot(
        uint256 seed,
        uint256 colorSeed
    ) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 10) {
            content = '(")-(")';
            name = "Holding food";
        }
        if (seed == 11) {
            content = "_/-\\_";
            name = "Standing";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan dy="65" x="270" fill="',
                        color.value,
                        '">',
                        content,
                        "</tspan>"
                    )
                ),
                name,
                color
            );
    }

    function calculateColorCount(
        uint256[4] memory colors
    ) private pure returns (string memory) {
        uint256 count;
        for (uint256 i = 0; i < 4; i++) {
            for (uint256 j = 0; j < 4; j++) {
                if (colors[i] == colors[j]) {
                    count++;
                }
            }
        }

        if (count == 4) {
            return "4";
        }
        if (count == 6) {
            return "3";
        }
        if (count == 8 || count == 10) {
            return "2";
        }
        if (count == 16) {
            return "1";
        }

        return "0";
    }
}
