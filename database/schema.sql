-- Create Enum Types for Strict Classification
CREATE TYPE tactic_stage AS ENUM ('Recon', 'Resource_Prep', 'Perimeter_Breach', 'Internal_Nav', 'Detection_Evasion', 'Ops_Consolidation', 'Objective_Execution', 'Exfiltration');
CREATE TYPE tool_class AS ENUM ('K', 'S', 'E', 'V', 'A');
CREATE TYPE mitigation_type AS ENUM ('Physical', 'Technical', 'Administrative');

-- Techniques Table
CREATE TABLE techniques (
    tech_id VARCHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    tactic tactic_stage NOT NULL,
    description TEXT,
    friction_score INT CHECK (friction_score BETWEEN 1 AND 10),
    stealth_rating INT CHECK (stealth_rating BETWEEN 1 AND 5),
    status VARCHAR(20) DEFAULT 'Draft' -- Draft, Under Review, Active, Legacy
);

-- Tools Table
CREATE TABLE tools (
    tool_id VARCHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    class tool_class NOT NULL,
    signature_json JSONB -- Stores audio/visual/electronic signatures
);

-- Mitigations Table
CREATE TABLE mitigations (
    mit_id VARCHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    type mitigation_type NOT NULL,
    function TEXT -- Deter, Detect, Delay, Deny, Respond
);

-- Many-to-Many Mapping Tables
CREATE TABLE rel_tech_tools (
    tech_id VARCHAR REFERENCES techniques(tech_id),
    tool_id VARCHAR REFERENCES tools(tool_id),
    PRIMARY KEY (tech_id, tool_id)
);

CREATE TABLE rel_tech_mits (
    tech_id VARCHAR REFERENCES techniques(tech_id),
    mit_id VARCHAR REFERENCES mitigations(mit_id),
    PRIMARY KEY (tech_id, mit_id)
);

-- Submission Table (Privacy First: No PII logging)
CREATE TABLE submissions (
    sub_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submitted_at TIMESTAMP DEFAULT NOW(),
    attribution_name TEXT,
    evidence_url TEXT,
    proposed_data JSONB NOT NULL, -- The TTP details
    status VARCHAR(20) DEFAULT 'Pending'
);
