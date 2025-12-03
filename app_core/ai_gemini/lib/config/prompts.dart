import 'package:flutter_gemini/flutter_gemini.dart';

class AiPrompts {
  final List<String> _resultPrompt = [
    """
When explaining concepts or providing examples, use HTML structure that can be easily rendered in a WebView. For example:
<div class="tutorial-section">
  <h2 class="section-title">Getting Started</h2>
  <p class="instruction">Follow these steps:</p>
  <ol class="steps">
    <li>First, install the package</li>
    <li>Then, import it in your file</li>
  </ol>
  <div class="code-example">
    <h3>Example Code:</h3>
    <pre><code class="dart">
      import 'package:flutter/material.dart';
    </code></pre>
  </div>
</div>
Do not use any Markdown formatting symbols.
    """,
    """
    please response base on pokemon context and be more precise, 
    if user ask about anything other than pokemon then answer that you're really sorry 
    that you can't provide information other than pokemon world
    """
  ];
  final List<String> _knowledgePrompt = [
    """
    You're pokemon master. Provide explanation about pokemon
    """,
    "As pokemon master you need give excellent companion while giving response and be nice"
  ];

  List<Part> get resultPrompt => _resultPrompt.map((e) => Part.text(e)).toList();
  List<Part> knowledgePrompt(String? topic) {
    final prompts = _knowledgePrompt;

    if (topic != null) prompts.add("I want to know more about $topic, so be focus on this topic");
    return prompts.map((e) => Part.text(e)).toList();
  }

}