Shader "Xiao/ColorChange2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PassRColor("PassRColor",Color) = (1,0,0,1)
        _PassBColor("PassBColor",Color) = (0,0,1,1)
 
 
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"  "IgnoreProjector" = "True"   "Queue" = "Transparent" }
        LOD 100
           
         ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
 
 
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
            fixed4 _PassRColor;  //项目demo只用到了两个通道(衣服和身体)
            fixed4 _PassBColor;
 


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            { 
                 fixed4 col = tex2D(_MainTex, i.uv);

          

               //这里是避免对帽子区域的颜色产生影响
                fixed rValue = col.r-col.b-col.g;
                fixed bValue = col.b-col.r-col.g;

               
                rValue = saturate(rValue);
                bValue = saturate(bValue);
  
               
                col.rgb = lerp(col.rgb, _PassRColor.rgb, rValue);
                col.rgb = lerp(col.rgb, _PassBColor.rgb, bValue);

                return col;
            }
            ENDCG
        }
    }
}
