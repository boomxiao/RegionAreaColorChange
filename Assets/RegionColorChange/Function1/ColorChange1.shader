Shader "Xiao/ColorChange1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RegionTex("RegionTex", 2D) = "white" {}
        _PassRColor("PassRColor",Color) = (1,0,0,1)
        _PassGColor("PassGColor",Color) = (0,1,0,1)
        _PassBColor("PassBColor",Color) = (0,0,1,1)
       
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;         
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _RegionTex;
            float4 _RegionTex_ST;
            fixed4 _PassRColor;  
            fixed4 _PassGColor;
            fixed4 _PassBColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 regionCol= tex2D(_RegionTex, i.uv);

                col.rgb = lerp(col.rgb, _PassRColor.rgb, regionCol.r);
                col.rgb = lerp(col.rgb, _PassGColor.rgb, regionCol.g);
                col.rgb = lerp(col.rgb, _PassBColor.rgb, regionCol.b);
                return col;
            }
            ENDCG
        }
    }
}
