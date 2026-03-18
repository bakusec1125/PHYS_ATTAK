// /api/v1/submit/index.js
import { createClient } from '@supabase/supabase-client';

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);

export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).send('Method Not Allowed');

  const { attribution_name, evidence_url, ...technique_data } = req.body;

  const { data, error } = await supabase
    .from('submissions')
    .insert([{
      attribution_name: attribution_name || 'Anonymous',
      evidence_url: evidence_url,
      proposed_data: technique_data,
      status: 'Pending'
    }]);

  if (error) return res.status(500).json({ error: error.message });

  return res.status(202).json({ message: "Submission added to vetting queue." });
}
