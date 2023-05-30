// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "../lib/base64.sol";
import "./ITokenDescriptor.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FODescriptorV2 is ITokenDescriptor {
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
        Trait memory crown = getCrown(seed / 100000000000000, colors[0]);
        Trait memory face = getFace(
            (seed % 1000000000000) / 10000000000,
            colors[1]
        );
        Trait memory body = getBody((seed % 100000000) / 1000000, colors[2]);
        Trait memory feet = getFeet((seed % 10000) / 100, colors[3]);
        string memory colorCount = calculateColorCount(colors);

        string memory rawSvg = string(
            abi.encodePacked(
                '<svg width="320" height="320" viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="100%" height="100%" fill="#1c0e03"/>',
                '<text x="170" y="130" font-family="Courier,monospace" font-weight="700" font-size="20" text-anchor="middle" letter-spacing="1">',
                '<animate attributeName="dy" values="0;50;0" dur="3s" repeatCount="indefinite" />',
                crown.content,
                face.content,
                body.content,
                feet.content,
                "</text>",
                SVG_END_TAG
            )
        );

        string memory encodedSvg = Base64.encode(bytes(rawSvg));
        string
            memory description = "Flappy Owl is ascii art, uniquely generated on the blockchain and stored on the blockchain forever.";

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                "{",
                                '"name":"FLAPPY OWL #',
                                tokenId.toString(),
                                '",',
                                '"description":"',
                                description,
                                '",',
                                '"image": "',
                                "data:image/svg+xml;base64,",
                                encodedSvg,
                                '",',
                                '"attributes": [{"trait_type": "Crown", "value": "',
                                crown.name,
                                " (",
                                crown.color.name,
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
                                '{"trait_type": "Feet", "value": "',
                                feet.name,
                                " (",
                                feet.color.name,
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
            return Color("#e60049", "UA Red");
        }
        if (seed == 11) {
            return Color("#82b6b9", "Pewter Blue");
        }
        if (seed == 12) {
            return Color("#b3d4ff", "Pale Blue");
        }
        if (seed == 13) {
            return Color("#00ffff", "Aqua");
        }
        if (seed == 14) {
            return Color("#0bb4ff", "Blue Bolt");
        }
        if (seed == 15) {
            return Color("#1853ff", "Blue RYB");
        }
        if (seed == 16) {
            return Color("#35d435", "Lime Green");
        }
        if (seed == 17) {
            return Color("#61ff75", "Screamin Green");
        }
        if (seed == 18) {
            return Color("#00bfa0", "Caribbean Green");
        }
        if (seed == 19) {
            return Color("#ffa300", "Orange");
        }
        if (seed == 20) {
            return Color("#fd7f6f", "Coral Reef");
        }
        if (seed == 21) {
            return Color("#d0f400", "Volt");
        }
        if (seed == 22) {
            return Color("#9b19f5", "Purple X11");
        }
        if (seed == 23) {
            return Color("#dc0ab4", "Deep Magenta");
        }
        if (seed == 24) {
            return Color("#f46a9b", "Cyclamen");
        }
        if (seed == 25) {
            return Color("#bd7ebe", "African Violet");
        }
        if (seed == 26) {
            return Color("#fdcce5", "Classic Rose");
        }
        if (seed == 27) {
            return Color("#FCE74C", "Gargoyle Gas");
        }
        if (seed == 28) {
            return Color("#eeeeee", "Bright Gray");
        }
        if (seed == 29) {
            return Color("#7f766d", "Sonic Silver");
        }

        return Color("", "");
    }

    function getCrown(
        uint256 seed,
        uint256 colorSeed
    ) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 10) {
            content = "'--'";
            name = "Ears";
        }
        if (seed == 11) {
            content = "((()))";
            name = "Two Block";
        }
        if (seed == 12) {
            content = "=+==+=";
            name = "Pigtails";
        }
        if (seed == 13) {
            content = "///";
            name = "Punk";
        }
        if (seed == 14) {
            content = "(\\_/)";
            name = "Feathers";
        }
        if (seed == 15) {
            content = "/--/";
            name = "Horns";
        }
        if (seed == 16) {
            content = "~~~";
            name = "Curly hair";
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
            content = "(o,o)";
            name = "Eyes open";
        }
        if (seed == 11) {
            content = "(-,-)";
            name = "Sleeping";
        }
        if (seed == 12) {
            content = "(o,-)";
            name = "Wink";
        }
        if (seed == 13) {
            content = "(o,O)";
            name = "Suspicious";
        }
        if (seed == 14) {
            content = "(^,^)";
            name = "Smile";
        }
        if (seed == 15) {
            content = "(o-o)";
            name = "Glasses";
        }
        if (seed == 16) {
            content = "[=,=]";
            name = "Robot";
        }
        if (seed == 16) {
            content = "($,$)";
            name = "Money-oriented";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan dy="20" x="170" fill="',
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
            content = "///[ :-]\\\\\\";
            name = "Feathers";
        }
        if (seed == 11) {
            content = "///{\\S/}\\\\\\";
            name = "Swag";
        }
        if (seed == 12) {
            content = "///{=|=}\\\\\\";
            name = "Muscular";
        }
        if (seed == 13) {
            content = "///(\\+/)\\\\\\";
            name = "Priest";
        }
        if (seed == 14) {
            content = "///{ :~}\\\\\\";
            name = "Shirt";
        }
        if (seed == 15) {
            content = "///{\\:/}\\\\\\";
            name = "Suit";
        }
        if (seed == 16) {
            content = "///{\\~/}\\\\\\";
            name = "Tuxedo";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan dy="25" x="170" fill="',
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

    function getFeet(
        uint256 seed,
        uint256 colorSeed
    ) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 10) {
            content = '~"~"~';
            name = "Holding food";
        }
        if (seed == 11) {
            content = '" "';
            name = "Normal";
        }

        return
            Trait(
                string(
                    abi.encodePacked(
                        '<tspan dy="25" x="170" fill="',
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