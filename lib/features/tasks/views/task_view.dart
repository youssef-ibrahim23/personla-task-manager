import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import 'package:personal_task/core/utils/DB/models/attachment.dart';
import 'package:personal_task/features/tasks/view-models/add_task_view_model.dart';
import 'package:personal_task/features/tasks/views/widgets/add_photo_button.dart';
import 'package:personal_task/features/tasks/views/widgets/attachments_grid.dart';
import 'package:personal_task/features/tasks/views/widgets/cutom_drop_down_button.dart';
import 'package:personal_task/features/tasks/views/widgets/date_time_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/DB/models/task.dart';
import '../../../core/utils/localization/locale_provider.dart';
import '../services/tasks_services.dart';

DateTime? selectedReminderDate;

bool isPublic = false;

class TaskView extends ConsumerStatefulWidget {
  final bool isUpdate;
  final Task? task;

  const TaskView({super.key, this.isUpdate = false, this.task});

  @override
  ConsumerState<TaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends ConsumerState<TaskView> {
  Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
  };

  String? selectedCategory;
  String? selectedPriority;
  DateTime? selectedEndDate;
  DateTime? selectedStartDate;
  List<Attachment> attachments = [];

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.task != null) {
      controllers['title']!.text = widget.task!.title;
      controllers['description']!.text = widget.task!.description;
      selectedCategory = widget.task!.category;
      selectedPriority = widget.task!.priority;
      selectedStartDate = widget.task!.startDate;
      selectedEndDate = widget.task!.endDate;
      selectedReminderDate = widget.task!.reminder;
      isPublic = widget.task!.isShared;
      if (widget.task!.attachments != null &&
          widget.task!.attachments!.isNotEmpty) {
        attachments = widget.task!.attachments!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        title: Text(
          widget.isUpdate ? 'Task Details' : 'Add Task',
          style: const TextStyle(
            color: AppColors.light,
            fontFamily: AppStrings.primaryFont,
            fontSize: 35,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              selectedReminderDate =
                  await TasksServices.pickEndDateTime(
                    context,
                    initialDate: widget.task?.reminder ?? DateTime.now(),
                  );
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  SizedBox(height: screenHeight * 0.01,),
                  Text(
                    'Add Reminder',
                    style: TextStyle(fontFamily: 'Luckiest Guy', fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            CustomTextField(
              hintText: 'Enter Task Title',
              controller: controllers['title']!,
              fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomTextField(
              hintText: 'Enter Task Description',
              controller: controllers['description']!,
              fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDropDownButton(
                  hintText: 'Select Task Category',
                  options: ['Work', 'Study', 'Personal'],
                  selectedValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                CustomDropDownButton(
                  hintText: 'Select Task Priority',
                  options: ['High', 'Medium', 'Low'],
                  selectedValue: selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            DateTimePicker(
              selectedDate: selectedStartDate,
              onChanged: (date) {
                setState(() {
                  selectedStartDate = date;
                });
              },
              hintText: 'Select Start Date & Time',
            ),
            SizedBox(height: screenHeight * 0.03),
            DateTimePicker(
              selectedDate: selectedEndDate,
              onChanged: (date) {
                setState(() {
                  selectedEndDate = date;
                });
              },
              hintText: 'Select End Date & Time',
            ),

            SizedBox(height: screenHeight * 0.02),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Public Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppStrings.primaryFont,
                      color: Colors.grey[700],
                    ),
                  ),
                  Switch(
                    value: isPublic,
                    onChanged: (bool value) {
                      setState(() {
                        isPublic = value;
                      });
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Text(
                  'Attachments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppStrings.primaryFont,
                  ),
                ),
                const Spacer(),
                Text(
                  '${attachments.length} images',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            AddPhotoButton(
              selectedImages: attachments,
              onImageSelected: (attachment) {
                setState(() {
                  attachments.add(attachment);
                });
              },
            ),

            SizedBox(height: screenHeight * 0.03),
            AttachmentsGrid(attachments: attachments),
            SizedBox(height: screenHeight * 0.04),
            Button(
              text: 'Save Task',
              onPressed: widget.isUpdate
                  ? () async {
                      widget.task!.title = controllers['title']!.text;
                      widget.task!.description =
                          controllers['description']!.text;
                      widget.task!.category = selectedCategory!;
                      widget.task!.priority = selectedPriority!;
                      widget.task!.startDate = selectedStartDate!;
                      widget.task!.endDate = selectedEndDate!;
                      widget.task!.attachments = attachments;
                      await ref
                          .read(taskViewModelProvider.notifier)
                          .updateTask(widget.task!);
                      Navigator.pop(context, true);
                    }
                  : () async {
                      Task task = Task(
                        title: controllers['title']!.text,
                        description: controllers['description']!.text,
                        category: selectedCategory ?? 'Personal',
                        priority: selectedPriority ?? 'Medium',
                        startDate: selectedStartDate ?? DateTime.now(),
                        endDate: selectedEndDate ?? DateTime.now(),
                        reminder: selectedReminderDate,
                        isShared: isPublic,
                        attachments: attachments,
                      );
                      await ref
                          .read(taskViewModelProvider.notifier)
                          .addTask(task);
                      Navigator.pop(context, true);
                    },
              state: ref.watch(taskViewModelProvider).isLoading,
              fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
