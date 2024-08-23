import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_genrater/feature/prompt/bloc/prompt_bloc.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  TextEditingController controller = TextEditingController();
  final PromptBloc promptBloc = PromptBloc();
  @override
  void initState() {
    promptBloc.add(PromptInitialEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Images🚀"),
      ),
      body: BlocConsumer<PromptBloc, PromptState>(
        bloc: promptBloc,
        listener: (context, state) {
        },
        builder: (context, state) {
          switch(state.runtimeType){
            case PromptGeneratingImageLoadState:
              return Center(child: CircularProgressIndicator());

            case PromptGeneratingImageErrorState:
              return Center(child: Text("Something went wrong"));

            case PromptGeneratingImageSuccessState:
            final successState = state as PromptGeneratingImageSuccessState;
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        width: double.maxFinite ,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(successState.uint8list))),
                      )),
                  Container(
                    height: 230,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          "Enter your prompt",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 40,
                          width: double.maxFinite,
                          child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.deepPurple),
                              ),
                              onPressed: () {
                                if (controller.text.isNotEmpty){
                                  promptBloc.add(PromptEnterEvent(prompt: controller.text));
                                }
                              },
                              icon: Icon(Icons.generating_tokens),
                              label: Text("Generate")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
