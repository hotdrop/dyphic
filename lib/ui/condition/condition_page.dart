import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/condition/condition_view_model.dart';
import 'package:dyphic/ui/widget/app_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.conditionPageTitle)),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ChangeNotifierProvider<ConditionViewModel>(
          create: (_) => ConditionViewModel.create(),
          builder: (context, _) {
            final pageState = context.select<ConditionViewModel, PageLoadingState>((vm) => vm.pageState);
            if (pageState.isLoadSuccess) {
              return _loadSuccessView(context);
            } else {
              return _nowLoadingView();
            }
          },
          child: _nowLoadingView(),
        ),
      ),
    );
  }

  Widget _nowLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    return ListView(
      children: [
        _overview(context),
        _clearButton(context),
        const Divider(),
        _conditionArea(context),
        const Divider(),
        _inputArea(context),
      ],
    );
  }

  Widget _overview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.conditionOverview),
          SizedBox(height: 8),
          Text(AppStrings.conditionDetail, style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }

  Widget _clearButton(BuildContext context) {
    final viewModel = Provider.of<ConditionViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: OutlinedButton(
            onPressed: () => viewModel.clear(),
            child: const Text(AppStrings.conditionClearSelectedLabel),
          ),
        ),
      ],
    );
  }

  Widget _conditionArea(BuildContext context) {
    final viewModel = Provider.of<ConditionViewModel>(context);
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 200,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8.0,
        children: viewModel.conditions
            .map((c) => ChoiceChip(
                  label: Text(c.name),
                  selected: viewModel.selectedCondition.name == c.name,
                  onSelected: (bool isSelected) {
                    viewModel.selectCondition(c);
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _inputArea(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 36.0, right: 36.0, top: 16.0, bottom: 36.0),
      child: Column(
        children: [
          _textFieldOnInputArea(context),
          const SizedBox(height: 16),
          if (appSettings.isLogin) _saveButtonOnInputArea(context),
        ],
      ),
    );
  }

  Widget _textFieldOnInputArea(BuildContext context) {
    final viewModel = Provider.of<ConditionViewModel>(context);
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: viewModel.editController,
      decoration: const InputDecoration(
        labelText: AppStrings.conditionInputLabel,
        border: OutlineInputBorder(),
        filled: true,
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (String? inputVal) => viewModel.inputValidator(inputVal),
      onFieldSubmitted: (String value) {
        viewModel.input(value);
      },
    );
  }

  Widget _saveButtonOnInputArea(BuildContext context) {
    final viewModel = Provider.of<ConditionViewModel>(context);

    String buttonName;
    if (viewModel.exist()) {
      buttonName = AppStrings.conditionEditButton;
    } else {
      buttonName = AppStrings.conditionNewButton;
    }

    return ElevatedButton(
      onPressed: viewModel.enableOnSave
          ? () async {
              bool? isSuccess = await AppProgressDialog(execute: viewModel.onSave).show(context);
              if (isSuccess) {
                await viewModel.refresh();
              }
            }
          : null,
      child: Text(buttonName),
    );
  }
}
