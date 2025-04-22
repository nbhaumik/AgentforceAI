global class LeadReplyEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        // Find Lead by email address
        List<Lead> leads = [SELECT Id, Name, Email FROM Lead WHERE Email = :env.fromAddress LIMIT 1];

        if (!leads.isEmpty()) {
            Lead l = leads[0];
            
            // Log the email as a Task or custom object
            Task t = new Task(
                WhatId = l.Id,
                Subject = 'Inbound Email',
                Description = email.plainTextBody,
                Status = 'Completed',
                Priority = 'Normal'
            );
            insert t;
        }

        result.success = true;
        return result;
    }
}