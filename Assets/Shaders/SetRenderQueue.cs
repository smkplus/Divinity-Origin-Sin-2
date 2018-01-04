/*
	SetRenderQueue.cs
 
	Sets the RenderQueue of an object's materials on Awake. This will instance
	the materials, so the script won't interfere with other renderers that
	reference the same materials.
*/
 
using UnityEngine;
 
[AddComponentMenu("Rendering/SetRenderQueue")]
 
public class SetRenderQueue : MonoBehaviour {
 
	[SerializeField]
	protected int[] m_queues = new int[]{3000};
	public Renderer rend;
	public Material[] materials;
	public float changeInterval = 0.33F;

	void Start() {
		rend = GetComponent<Renderer>();
		rend.enabled = true;
	}
 
	protected void Awake() {
		if (materials.Length == 0)
			return;

		// we want this material index now
		int index = Mathf.FloorToInt(Time.time / changeInterval);

		// take a modulo with materials count so that animation repeats
		index = index % materials.Length;

		// assign it to the renderer
		rend.sharedMaterial = materials[index];
	
		for (int i = 0; i < materials.Length && i < m_queues.Length; ++i) {
			materials[i].renderQueue = m_queues[i];
		}
	}
}