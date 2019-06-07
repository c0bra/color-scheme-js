export type SchemeColor = 'mono' | 'contrast' | 'triade' | 'tetrade' | 'analogic'
export type VariationColor = 'default' | 'pastel' | 'soft' | 'light' | 'hard' | 'pale'

export interface SchemeOutput {
    [name: string]: ColorScheme
    analogic: ColorScheme & {
        add_complement(add: boolean): void
    }
}

export class ColorScheme {
    colors(): string[]
    colorset(): string[][]
    distance(distance: number): ColorScheme
    from_hex(hex: string): ColorScheme
    from_hue(degrees: number): ColorScheme
    rgb2ryb(...rgb: number[] | number[][]): ColorScheme
    rgb2hsv(...rgb: number[] | number[][]): ColorScheme
    scheme<C extends SchemeColor>(color: C): SchemeOutput[C]
    variation(color: VariationColor): ColorScheme
    web_safe(safe: boolean): ColorScheme
}

export default ColorScheme